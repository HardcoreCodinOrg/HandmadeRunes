package application

GetTicks :: proc() -> u64;

Perf :: struct {
    delta: struct {ticks        : u64, seconds: f32},
    accum: struct {ticks, frames: u64              },
    ticks: struct {before, after: u64},
    avg: struct {
        frames_per_tick, 
        ticks_per_frame: f64,

        frames_per_second, 
        milliseconds_per_frame, 
        microseconds_per_frame, 
        nanoseconds_per_frame: u64
    },
    ticks_per_interval, 
    ticks_per_second: u64,

    seconds_per_tick, 
    milliseconds_per_tick, 
    microseconds_per_tick, 
    nanoseconds_per_tick: f64,

    getTicks: GetTicks
};
perf: Perf;

initPerf :: proc(getTicksCB: GetTicks, sys_ticks_per_second: u64) {
    using perf;

    ticks_per_second = sys_ticks_per_second;
    getTicks = getTicksCB;
    ticks.before = getTicks();
    seconds_per_tick = 1.0 / f64(ticks_per_second);
    milliseconds_per_tick = 1000.0 / f64(ticks_per_second);
    microseconds_per_tick = 1000.0 * milliseconds_per_tick;
    nanoseconds_per_tick = 1000.0 * microseconds_per_tick;
    ticks_per_interval = ticks_per_second / 4;
}

startFramePerf :: inline proc() {
    using perf;
    ticks.after, ticks.before = ticks.before, getTicks();
    delta.ticks = ticks.before - ticks.after;
    delta.seconds = f32(f64(delta.ticks) * seconds_per_tick);
}

endFramePerf :: inline proc() {
    using perf;
    ticks.after = getTicks();
    delta.ticks = ticks.after - ticks.before;
    
    // Accumulate:
    accum.frames += 1;
    accum.ticks += delta.ticks;
    if accum.ticks >= ticks_per_interval { // Summarize:
        avg.frames_per_tick = f64(accum.frames) / f64(accum.ticks);
        avg.ticks_per_frame = f64(accum.ticks) / f64(accum.frames);
        avg.frames_per_second = u64(avg.frames_per_tick * f64(ticks_per_second));
        avg.milliseconds_per_frame = u64(f64(avg.ticks_per_frame) * milliseconds_per_tick);
        avg.microseconds_per_frame = u64(f64(avg.ticks_per_frame) * microseconds_per_tick);
        avg.nanoseconds_per_frame = u64(f64(avg.ticks_per_frame) * nanoseconds_per_tick);
        accum.ticks = 0;
        accum.frames = 0;
    }
}