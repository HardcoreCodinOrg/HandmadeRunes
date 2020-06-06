package main

when ODIN_OS == "windows" do import platform "platforms/windows"

main :: proc() {
    platform.run_application();
}