const Builder = @import("std").build.Builder;

pub fn build(b: *Builder) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const gtk = b.addModule("gtk", .{ .source_file = .{ .path = "src/gtk/lib.zig" } });
    const gui = b.addModule("gui", .{ .source_file = .{ .path = "src/gui/gui.zig" } });

    {
        const exe = b.addExecutable(.{
            .name = "rissa",
            .root_source_file = .{ .path = "src/widgets/rissaWidget.zig" },
            .target = target,
            .optimize = optimize,
        });
        exe.addModule("gtk", gtk);
        exe.addModule("gui", gui);
        exe.linkSystemLibrary("c");
        exe.linkSystemLibrary("gtk+-3.0");
        b.installArtifact(exe);
        const run_cmd = b.addRunArtifact(exe);
        run_cmd.step.dependOn(b.getInstallStep());
        if (b.args) |args| {
            run_cmd.addArgs(args);
        }
        const run_step = b.step("rissa", "Run the app");
        run_step.dependOn(&run_cmd.step);
    }
    {
        const exe = b.addExecutable(.{
            .name = "vendiScooter",
            .root_source_file = .{ .path = "./src/widgets/vendiScooterWidget.zig" },
            .target = target,
            .optimize = optimize,
        });
        exe.addModule("gtk", gtk);
        exe.addModule("gui", gui);
        exe.linkSystemLibrary("c");
        exe.linkSystemLibrary("gtk+-3.0");
        b.installArtifact(exe);
        const run_cmd = b.addRunArtifact(exe);
        run_cmd.step.dependOn(b.getInstallStep());
        if (b.args) |args| {
            run_cmd.addArgs(args);
        }
        const run_step = b.step("vendiScooter", "Run the app");
        run_step.dependOn(&run_cmd.step);
    }
}
