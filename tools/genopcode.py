import sys
import json
import re

if len(sys.argv) < 2:
    print("Specify a json file")
    sys.exit(1)

json_filename = sys.argv[1]
json_file = open(json_filename, "r")
json = json.load(json_file)


def ada_mnemonic(mnemonic):
    if mnemonic == "AND":
        return "ANDD"
    elif mnemonic == "OR":
        return "ORR"
    elif mnemonic == "XOR":
        return "XORR"
    else:
        return mnemonic


def ada_operand(operand):
    if operand == "r8":
        return "Read_R8 (CPU)"
    elif operand == "d8":
        return "Read_D8 (CPU)"
    elif operand == "d16":
        return "Read_D16 (CPU)"
    elif operand == "(a8)":
        return "Read_A8 (CPU)"
    elif operand in ["(a16)", "a16"]:
        return "Read_A16 (CPU)"
    elif re.match(r"\d+H", operand):
        return "16#{}#".format(operand[:-1])
    else:
        no_paren = re.sub(r"\((.*?)\)", r"+\1", operand)
        inc = re.sub(r"(.+?)\+", r"Incr (CPU, \1)", no_paren)
        dec = re.sub(r"(.+?)\-", r"Decr (CPU, \1)", inc)

        return dec


def gen_from_json(procname_prefix, content):
    # Gen what should be in table
    print("####FOR TABLE####")
    for x in content:
        addr = int(x["addr"], base=16)
        cycles = x["cycles"]
        length = x["length"]

        instruction_access = "{}_{:02X}'Access".format(procname_prefix, addr)

        if len(cycles) == 1:
            cycles_rec = "new Cycles_Rec'(False, {})".format(cycles[0])
        elif len(cycles) == 2:
            cycles_rec = "new Cycles_Rec'(True, {}, {})".format(cycles[0], cycles[1])

        print(
            "       16#{:02X}# => ({}, {}, {}),".format(
                addr, cycles_rec, length, instruction_access
            )
        )
    print("#################")

    # Gen what should be in opcodes package spec
    print("####FOR OPCODES SPEC####")
    for x in content:
        addr = int(x["addr"], base=16)

        procname = "{}_{:02X}".format(procname_prefix, addr)

        print("   procedure {} (CPU : in out CPU_T);".format(procname))
    print("########################")

    # Gen what should be in opcodes package body
    print("####FOR OPCODES BODY####")
    for x in content:
        addr = int(x["addr"], base=16)
        mnemonic = ada_mnemonic(x["mnemonic"])
        operands = ""

        if "operand2" in x and x["operand2"] == "SP+r8":
            # We use a special mnemonic for this one
            mnemonic = "LDHL"

            operands = ", {}".format(ada_operand("r8"))
        elif mnemonic != "PREFIX":
            # Ignore operands for PREFIX
            if "operand1" in x:
                operands += ", {}".format(ada_operand(x["operand1"]))

            if "operand2" in x:
                operands += ", {}".format(ada_operand(x["operand2"]))

        procname = "{}_{:02X}".format(procname_prefix, addr)

        print("   procedure {} (CPU : in out CPU_T) is".format(procname))
        print("   begin")
        print("      {} (CPU{});".format(mnemonic, operands))
        print("   end {};".format(procname, procname))
        print("")
    print("########################")


def gen_mnemonic_from_json(content):
    print("####MNEMONIC####")
    for x in content:
        addr = int(x["addr"], base=16)
        mnemonic = x["mnemonic"]

        if "operand1" in x:
            mnemonic += " " + x["operand1"]

        if "operand2" in x:
            mnemonic += ", " + x["operand2"]

        print('       16#{:02X}# => To_Unbounded_String ("{}"),'.format(addr, mnemonic))
    print("################")


content = []

for value in json["unprefixed"].values():
    content.append(value)

content.sort(key=(lambda x: int(x["addr"], base=16)))

gen_from_json("OPCode", content)
gen_mnemonic_from_json(content)

content = []

for value in json["cbprefixed"].values():
    content.append(value)

content.sort(key=(lambda x: int(x["addr"], base=16)))

gen_from_json("CB_OPCode", content)
gen_mnemonic_from_json(content)
