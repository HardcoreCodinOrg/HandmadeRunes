package application

import "core:mem"

Color :: struct #packed { B, G, R, A: u8 };
Pixel :: struct #raw_union { color: Color, value: u32};

MAX_WIDTH :: 3840;
MAX_HEIGHT :: 2160;
MAX_SIZE :: MAX_WIDTH * MAX_HEIGHT;
PIXEL_SIZE :: 4;

FrameBuffer :: struct {
    width, height: u16,
    size: u32,
    pixels: ^[MAX_SIZE]Pixel
};
frame_buffer: FrameBuffer = {
    width  = MAX_WIDTH,
    height = MAX_HEIGHT,
    size   = MAX_SIZE,
    pixels = cast(^[MAX_SIZE]Pixel)(mem.alloc(MAX_SIZE * PIXEL_SIZE))
};

is_running,
in_fps_mode: bool;

resize :: inline proc() {
    generateRays();
    updateDimensionsInHUD(frame_buffer.width, frame_buffer.height);
}

update :: proc() {
    startFramePerf();

    using camera.transform;

    if mouse.wheel.scrolled {
        mouse.wheel.scrolled = false;
        if in_fps_mode do
            onMouseScrolledFps();
        else do
            onMouseScrolledOrb();
        mouse.wheel.scroll_amount = 0;
    }

    if mouse.relative.changed {
        mouse.relative.changed = false;
        if in_fps_mode do
            onMouseMovedFps();
        else do
            onMouseMovedOrb();
        mouse.relative.x = 0;
        mouse.relative.y = 0;
    }

    if in_fps_mode do onUpdateFps();

    controller := in_fps_mode ? &fps_controller.controller : &orb_controller.controller;

    if controller.zoomed {
        controller.zoomed = false;
        generateRays();
    }

    if controller.rotated {
        controller.rotated = false;
        controller.moved = true;
        transposeMatrix(&rotation_matrix, &rotation_matrix_inverted);
    }

    if controller.moved {
        controller.moved = false;
        
        sphere: ^Sphere;        
        for i in 0..<SPHERE_COUNT {
            sphere = &ray_tracer.spheres[i];
            using sphere;
            view_position = world_position;
            view_position -= position;
            multiplyVectorByMatrixInPlace(&view_position, &rotation_matrix_inverted);
        }
    }

    traceRays();

    endFramePerf();

    if hud.is_visible {
        if perf.accum.frames != 0 do updateCountersInHUD();
        drawText(hud.text, hud.color, frame_buffer.width - HUD_RIGHT - HUD_WIDTH, HUD_TOP);
    }

    if keyboard.toggle_hud.is_pressed {
        keyboard.toggle_hud.is_pressed = false;
        hud.is_visible = !hud.is_visible;
    }

    if mouse.double_clicked {
        mouse.double_clicked = false;
        in_fps_mode = !in_fps_mode;
        updateControllerModeInHUD();
    }
}

initApplication :: proc(getTicksCB: GetTicks, ticks_per_second: u64) {
    initPerf(getTicksCB, ticks_per_second);
    initHUD();
    initCamera();
    initRayTracer();

    is_running = true;

    using camera.transform;

    position.x = 3;
    position.y = 3;
    position.z = -ORB_TARGET_DISTANCE;

    using orb_controller;
    target = position + target_distance*forward_direction^;
    moved = true;
}