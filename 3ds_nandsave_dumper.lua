local function pause(seconds)
    local start = os.time()
    while true do
        if os.difftime(os.time(), start) > seconds then
            break
        end
    end
end
local headerText = "3DS NAND Savegame Dumper v1.0.0\nBy ManiacOfHomebrew\nExcludes config, NIM (eShop), and Act (NNID) saves\n\n"
ui.show_text(headerText .. "Starting in 5 seconds...\nPlease wait.")
pause(5)
ui.show_text(headerText .. "In progress!\nPlease wait.")
if not fs.is_file("S:/ctrnand_fat.bin") then
    ui.show_text(headerText .. "Error: CTRNAND cannot be mounted.\nThe system will power off in 10 seconds.")
    pause(10)
    sys.power_off()
end
if not fs.is_dir("1:/data/" .. sys.sys_id0) then
    ui.show_text(headerText .. "Error: Data does not exist.\nThe system will power off in 10 seconds.")
    pause(10)
    sys.power_off()
end
if not fs.sd_is_mounted() then
    ui.show_text(headerText .. "Error: SD card is not mounted.\nThe system will power off in 10 seconds.")
    pause(10)
    sys.power_off()
end
pcall(fs.remove, "0:/nandsaves/" .. sys.sys_id0, {recursive = true})
pcall(fs.mkdir, "0:/nandsaves")
local success = pcall(fs.copy, "1:/data/" .. sys.sys_id0, "0:/nandsaves/" .. sys.sys_id0, {recursive = true, no_cancel = true, silent = true})
if not success then
    ui.show_text(headerText .. "Error: Unable to copy data.\nThe system will power off in 10 seconds.")
    pause(10)
    sys.power_off()
end
pcall(fs.remove, "0:/nandsaves/" .. sys.sys_id0 .. "/sysdata/00010017", {recursive = true})
pcall(fs.remove, "0:/nandsaves/" .. sys.sys_id0 .. "/sysdata/0001002c", {recursive = true})
pcall(fs.remove, "0:/nandsaves/" .. sys.sys_id0 .. "/sysdata/00010038", {recursive = true})
ui.show_text(headerText .. "Success!\nThe system will power off in 10 seconds.")
pause(10)
sys.power_off()