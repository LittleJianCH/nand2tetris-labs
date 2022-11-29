if #arg < 1 then
    print("Usage: lua Assembler.lua <file.asm>")
    os.exit()
end

local file = arg[1]
local outputFile = file:sub(1, #file - 4) .. ".hack"

local function tobinary(number)
    local binary = ''
    for i = 1, 15 do
        binary = number % 2 .. binary
        number = math.floor(number / 2)
    end
    return binary
end

VariablesCnt = 0
local function aInstruction(line, symbols, variables)
    local address = line:sub(2)

    if tonumber(address) then
        address = tonumber(address)
    else
        local name = address
        address = symbols[name] or variables[name] or (VariablesCnt + 16)
        if not symbols[name] and not variables[name] then
            variables[name] = VariablesCnt + 16
            VariablesCnt = VariablesCnt + 1
        end
    end

    return '0' .. tobinary(address)
end

local function generateCInstructionTable()
    local table = {}
    local comps = {
        ['0']   = '0101010',
        ['1']   = '0111111',
        ['-1']  = '0111010',
        ['D']   = '0001100',
        ['A']   = '0110000',
        ['!D']  = '0001101',
        ['!A']  = '0110001',
        ['-D']  = '0001111',
        ['-A']  = '0110011',
        ['D+1'] = '0011111',
        ['A+1'] = '0110111',
        ['D-1'] = '0001110',
        ['A-1'] = '0110010',
        ['D+A'] = '0000010',
        ['D-A'] = '0010011',
        ['A-D'] = '0000111',
        ['D&A'] = '0000000',
        ['D|A'] = '0010101',
        ['M']   = '1110000',
        ['!M']  = '1110001',
        ['-M']  = '1110011',
        ['M+1'] = '1110111',
        ['M-1'] = '1110010',
        ['D+M'] = '1000010',
        ['D-M'] = '1010011',
        ['M-D'] = '1000111',
        ['D&M'] = '1000000',
        ['D|M'] = '1010101'
    }

    local dests = {
        ['']     = '000',
        ['M=']   = '001',
        ['D=']   = '010',
        ['MD=']  = '011',
        ['A=']   = '100',
        ['AM=']  = '101',
        ['AD=']  = '110',
        ['AMD='] = '111'
    }

    local jumps = {
        ['']     = '000',
        [';JGT'] = '001',
        [';JEQ'] = '010',
        [';JGE'] = '011',
        [';JLT'] = '100',
        [';JNE'] = '101',
        [';JLE'] = '110',
        [';JMP'] = '111'
    }

    for comp, compB in pairs(comps) do
        for dest, destB in pairs(dests) do
            for jump, jumpB in pairs(jumps) do
                local pattern = dest .. comp .. jump
                table[pattern] = '111' .. compB .. destB .. jumpB
            end
        end
    end

    return table
end

local instructions = {}
local symbols = {
    ['R0'] = 0,
    ['R1'] = 1,
    ['R2'] = 2,
    ['R3'] = 3,
    ['R4'] = 4,
    ['R5'] = 5,
    ['R6'] = 6,
    ['R7'] = 7,
    ['R8'] = 8,
    ['R9'] = 9,
    ['R10'] = 10,
    ['R11'] = 11,
    ['R12'] = 12,
    ['R13'] = 13,
    ['R14'] = 14,
    ['R15'] = 15,
    ['SCREEN'] = 16384,
    ['KBD'] = 24576,
    ['SP'] = 0,
    ['LCL'] = 1,
    ['ARG'] = 2,
    ['THIS'] = 3,
    ['THAT'] = 4
}

for line in io.lines(file) do
    -- remove comment
    line = line:match('^(.-)%s*//') or line
    -- trim the line
    line = line:gsub("^%s*(.-)%s*$", "%1")

    if #line == 0 or line:sub(1, 1) == '/' then
    elseif line:sub(1, 1) == '(' then
        local name = line:sub(2, #line - 1)
        symbols[name] = #instructions
    else
        instructions[#instructions + 1] = line
    end
end

local output = io.open(outputFile, "w")

if output then
    io.output(output)
end

local cInstructionTable = generateCInstructionTable()
local variables = {}
for _, instr in pairs(instructions) do
    if instr:sub(1, 1) == '@' then
        io.write(aInstruction(instr, symbols, variables))
    else
        io.write(cInstructionTable[instr])
    end

    io.write("\n")
end
