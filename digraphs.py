import json
import unicodedata

control_names = {
    0: 'NULL (NUL)',
    1: 'START OF HEADING (SOH)',
    2: 'START OF TEXT (STX)',
    3: 'END OF TEXT (ETX)',
    4: 'END OF TRANSMISSION (EOT)',
    5: 'ENQUIRY (ENQ)',
    6: 'ACKNOWLEDGE (ACK)',
    7: 'BELL (BEL)',
    8: 'BACKSPACE (BS)',
    9: 'CHARACTER TABULATION (HT)',
    10: 'LINE FEED (LF)',
    11: 'LINE TABULATION (VT)',
    12: 'FORM FEED (FF)',
    13: 'CARRIAGE RETURN (CR)',
    14: 'SHIFT OUT (SO)',
    15: 'SHIFT IN (SI)',
    16: 'DATALINK ESCAPE (DLE)',
    17: 'DEVICE CONTROL ONE (DC1)',
    18: 'DEVICE CONTROL TWO (DC2)',
    19: 'DEVICE CONTROL THREE (DC3)',
    20: 'DEVICE CONTROL FOUR (DC4)',
    21: 'NEGATIVE ACKNOWLEDGE (NAK)',
    22: 'SYNCHRONOUS IDLE (SYN)',
    23: 'END OF TRANSMISSION BLOCK (ETB)',
    24: 'CANCEL (CAN)',
    25: 'END OF MEDIUM (EM)',
    26: 'SUBSTITUTE (SUB)',
    27: 'ESCAPE (ESC)',
    28: 'FILE SEPARATOR (IS4)',
    29: 'GROUP SEPARATOR (IS3)',
    30: 'RECORD SEPARATOR (IS2)',
    31: 'UNIT SEPARATOR (IS1)',
    127: 'DELETE (DEL)',
    128: 'PADDING CHARACTER (PAD)',
    129: 'HIGH OCTET PRESET (HOP)',
    130: 'BREAK PERMITTED HERE (BPH)',
    131: 'NO BREAK HERE (NBH)',
    132: 'INDEX (IND)',
    133: 'NEXT LINE (NEL)',
    134: 'START OF SELECTED AREA (SSA)',
    135: 'END OF SELECTED AREA (ESA)',
    136: 'CHARACTER TABULATION SET (HTS)',
    137: 'CHARACTER TABULATION WITH JUSTIFICATION (HTJ)',
    138: 'LINE TABULATION SET (VTS)',
    139: 'PARTIAL LINE FORWARD (PLD)',
    140: 'PARTIAL LINE BACKWARD (PLU)',
    141: 'REVERSE LINE FEED (RI)',
    142: 'SINGLE-SHIFT TWO (SS2)',
    143: 'SINGLE-SHIFT THREE (SS3)',
    144: 'DEVICE CONTROL STRING (DCS)',
    145: 'PRIVATE USE ONE (PU1)',
    146: 'PRIVATE USE TWO (PU2)',
    147: 'SET TRANSMIT STATE (STS)',
    148: 'CANCEL CHARACTER (CCH)',
    149: 'MESSAGE WAITING (MW)',
    150: 'START OF GUARDED AREA (SPA)',
    151: 'END OF GUARDED AREA (EPA)',
    152: 'START OF STRING (SOS)',
    153: 'SINGLE GRAPHIC CHARACTER INTRODUCER (SGCI)',
    154: 'SINGLE CHARACTER INTRODUCER (SCI)',
    155: 'CONTROL SEQUENCE INTRODUCER (CSI)',
    156: 'STRING TERMINATOR (ST)',
    157: 'OPERATING SYSTEM COMMAND (OSC)',
    158: 'PRIVACY MESSAGE (PM)',
    159: 'APPLICATION PROGRAM COMMAND (APC)',
}

def get_name(x):
    return control_names.get(ord(x)) or unicodedata.name(x)

with open('digraphs.tsv') as infile:
    with open('digraphs.json', 'w') as outfile:
        parts = [line.strip().split("\t") for line in infile]
        json.dump([[digraph, int(s, 16), get_name(chr(int(s, 16)))] for digraph, s in parts], outfile)
with open('digraphs-custom.tsv') as infile:
    with open('digraphs-custom.json', 'w') as outfile:
        parts = [line.strip().split("\t") for line in infile]
        json.dump([[digraph, int(s), get_name(chr(int(s)))] for digraph, s in parts], outfile)
