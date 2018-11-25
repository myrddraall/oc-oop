local shell = require("shell");
local args = {...};
local installDir = "";
if args[1] then
    installDir = args[1];
end


shell.execute('rm -r ' .. installDir .. '/usr/lib/oop');
shell.execute('cp -r ./usr/* ' .. installDir .. '/usr/');