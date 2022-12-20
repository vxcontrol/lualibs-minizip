local zip = require'minizip'
local pp = require'pp'

local filename = 'test.zip'
local password = 'doh'
local hello = 'hello'
local hello_again = 'hello again'

local z

-- make zip file from lua code
z = zip.open(filename, 'w')
z:add_file{filename = 'dir1/file1.txt', password = password, date = os.time(os.date('*t'))}
z:write(hello)
z:close_file()

z:add_file{filename = 'dir1/file2.txt'}
z:write(hello_again)
z:close_file()

z:close('one dir, two files')

-- parse zip file from lua code
z = zip.open(filename)
pp(z:get_global_info())

for info in z:files() do
	pp(info)
end

assert(z:extract('dir1/file1.txt', password) == hello)
assert(z:extract'dir1/file2.txt' == hello_again)

z:close()

os.remove(filename)

-- make zip file from command line tool
zip.zip("-9", filename, arg[0])
zip.zip("-9", "-a", filename, arg[0])

-- parse zip file from command line tool
zip.unzip("-l", filename)

-- auxilary methods
print("is file exist: ", zip.check_file_exists(filename))
print("get file date (before): ", os.date("%x %X", zip.get_file_date(filename)))
print("change file date", zip.change_file_date(filename, os.time(os.date('*t'))))
print("get file date (after): ", os.date("%x %X", zip.get_file_date(filename)))

os.remove(filename)

print("test done")
