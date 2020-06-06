package main

when ODIN_OS == "windows" do import platform "platform/windows"

main :: proc() {
	platform.run_application();
}