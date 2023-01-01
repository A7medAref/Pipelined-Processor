import re
import os
op_codes = {
    "nop": "00000",
    "setc": "00001",
    "clrc": "00010",
    "not": "00011",
    "inc": "00100",
    "dec": "00101",
    "out": "00110",
    "in": "00111",
    "mov": "11000", 
    "add": "11001",
    "sub": "11010",
    "and": "11100",
    "or": "11101",
    "shl": "11110",
    "shr": "11111",
    "push": "01000",
    "pop": "01001",
    "ldm": "01110",
    "ldd": "01010",
    "std": "01100",
    "jz": "10000",
    "jn": "10001",
    "jc": "10010",
    "jmp": "10011",
    "call": "10100",
    "ret": "10101",
    "rti": "10110",
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

def push_zeros_to_16_bit(str):
    return ((16 - len(str))*"0") + str

def append_zeros_to_16_bit(str):
    return str + ((16 - len(str))*"0")

def check_immediate(instruction):
    if(len(instruction) == 2):
        return False

    if instruction[0] == 'ldm': 
        return True
    #print(instruction[2].isnumeric())
    return (instruction[0] == 'shr' or instruction[0] == 'shl') and instruction[2].strip().isnumeric()

file_name= './assembly.txt'
assembly_file = open(file_name, 'r')
machine_code = open('machine_code.txt', 'w')
for line in assembly_file:
    line = line.lower().replace(',', ' ')
    line = re.sub(' +', ' ', line)
    op_code = ""
    curr_instruction = line.split(' ')
    try:
        if check_immediate(curr_instruction):
            #print('I am ldm', curr_instruction[2])
            #print('success', curr_instruction)
            op_code += op_codes[curr_instruction[0]]
            op_code += op_codes[curr_instruction[1]]
            op_code = append_zeros_to_16_bit(op_code)
            machine_code.write(op_code+'\n')
            machine_code.write(push_zeros_to_16_bit(DecimalToBinary(int(curr_instruction[2])))+'\n')
            #print(op_code)
            #print(push_zeros_to_16_bit(DecimalToBinary(int(curr_instruction[2])))+'\n')

        else :
            for code in curr_instruction:
                code = code.strip() 
                op_code += op_codes[code]
            op_code = append_zeros_to_16_bit(op_code)
            machine_code.write(op_code+'\n')
            #print('success', curr_instruction)
            #print(op_code)
    except:
        print("Invalid assembly code", curr_instruction)

print('Machine code successfully generated in machine_code.txt')
assembly_file.close()
machine_code.close()