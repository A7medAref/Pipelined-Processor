import re
instructions_op_codes = {
    "nop": {"code": "00000", "num_of_operands": 0},
    "setc": {"code": "00001", "num_of_operands": 0},
    "clrc": {"code": "00010", "num_of_operands": 0},
    "not": {"code": "00011", "num_of_operands": 1},
    "inc": {"code": "00100", "num_of_operands": 1},
    "dec": {"code": "00101", "num_of_operands": 1},
    "out": {"code": "00110", "num_of_operands": 1},
    "in": {"code": "00111", "num_of_operands": 1},
    "mov": {"code": "11000", "num_of_operands": 2},
    "add": {"code": "11001", "num_of_operands": 2},
    "sub": {"code": "11010", "num_of_operands": 2},
    "and": {"code": "11100", "num_of_operands": 2},
    "or": {"code": "11101", "num_of_operands": 2},
    "shl": {"code": "11110", "num_of_operands": 2},
    "shr": {"code": "11111", "num_of_operands": 2},
    "push": {"code": "01000", "num_of_operands": 1},
    "pop": {"code": "01001", "num_of_operands": 1},
    "ldm": {"code": "01110", "num_of_operands": 2},
    "ldd": {"code": "01010", "num_of_operands": 2},
    "std": {"code": "01100", "num_of_operands": 2},
    "jz": {"code": "10000", "num_of_operands": 1},
    "jn": {"code": "10001", "num_of_operands": 1},
    "jc": {"code": "10010", "num_of_operands": 1},
    "jmp": {"code": "10011", "num_of_operands": 1},
    "call": {"code": "10100", "num_of_operands": 1},
    "ret": {"code": "10101", "num_of_operands": 0},
    "rti": {"code": "10110", "num_of_operands": 0}
}

registers_op_codes = {
    "r0": "000",
    "r1": "001",
    "r2": "010",
    "r3": "011",
    "r4": "100",
    "r5": "101",
    "r6": "110",
    "r7": "111"
}


def DecimalToBinary(num):
    st = ""
    if num >= 1:
        st += DecimalToBinary(num // 2)
    if num % 2 == 0:
        return st + "0"
    return st + "1"


def hexaToBinary(num):
    scale = 16
    num_of_bits = 16
    hexa = bin(int(num, scale))[2:].zfill(num_of_bits)
    return hexa


def push_zeros_to_16_bit(str):
    return ((16 - len(str))*"0") + str


def append_zeros_to_16_bit(str):
    return str + ((16 - len(str))*"0")


def check_immediate(instruction):
    if (len(instruction) != 3):
        return False

    if instruction[0] == 'ldm':
        return True
    # print(instruction[2].isnumeric())
    return (instruction[0] == 'shr' or instruction[0] == 'shl') and int(instruction[2].strip(), 16)


def org_behaviour(file, curr_line, org_address):
    for i in range(curr_line, org_address):
        file.write('0000000000000000\n')


def get_code_and_type(instruction):
    if instruction not in instructions_op_codes:
        return None
    return instructions_op_codes[instruction]


# SETC
# INC A1
# INC A1 , A2


# add r1 , r2
# register , register
def valid_num_of_operands(instruction, num_of_operands):
    # instruction = instruction.strip()
    if num_of_operands == 0:
        return instruction.find(' ') == -1

    if num_of_operands == 1:
        return len(instruction.split(' ')) == 2

    instruction_without_op_code = re.split(
        ' ?, ?', instruction[instruction.find(' ')+1:])
    return len(instruction_without_op_code) == 2


# print(check_valid_num_of_operands("Add r 1, r 2", 2))
file_name = './assembly.txt'
assembly_file = open(file_name, 'r')
machine_code = open('machine_code.txt', 'w')
current_line = 0
for line in assembly_file:
    line = line.lower().strip()
    # line = line.lower().replace(',', ' ')
    if len(line) == 0:
        continue
    line = re.sub(' +', ' ', line)
    op_code = ""
    curr_instruction = line.split(' ')
    try:
        if len(curr_instruction) == 0 or curr_instruction[0] == '':
            continue

        if curr_instruction[0] == '.org':
            org_behaviour(machine_code, current_line,
                          int(curr_instruction[1], 16))
            current_line = int(curr_instruction[1], 16)

        info = get_code_and_type(curr_instruction[0])

        if info is None:
            raise Exception('invalid instruction')

        if not valid_num_of_operands(line, info['num_of_operands']):
            raise Exception('invalid number of operands')

        if info["num_of_operands"] == 0:
            op_code = append_zeros_to_16_bit(info["code"])
        elif info["num_of_operands"] == 1:
            op_codes = line.split(' ')
            op_code = info["code"]
            op_code += registers_op_codes[op_codes[1]]
            op_code = append_zeros_to_16_bit(op_code)
        else:
            

        machine_code.write(f"{op_code}\n")
        # elif check_immediate(curr_instruction):
        #     # print('I am ldm', curr_instruction[2])
        #     # print('success', curr_instruction)
        #     op_code += op_codes[curr_instruction[0]]
        #     op_code += op_codes[curr_instruction[1]]
        #     op_code = append_zeros_to_16_bit(op_code)
        #     machine_code.write(op_code+'\n')
        #     machine_code.write(hexaToBinary(curr_instruction[2])+'\n')
        #     current_line += 2

        else:
            for code in curr_instruction:
                code = code.strip()
                op_code += op_codes[code]
            op_code = append_zeros_to_16_bit(op_code)
            machine_code.write(op_code+'\n')
            current_line += 1
            # print('success', curr_instruction)
            # print(op_code)
    except:
        pass
        # print("Invalid assembly code", curr_instruction)
        # exit(0)

print('Machine code successfully generated in machine_code.txt')
assembly_file.close()
machine_code.close()
