PROGRAM program0
  VAR
    Up AT %IX100.1 : BOOL;
    Down AT %IX100.3 : BOOL;
    Start AT %IX100.6 : BOOL := 0;
    Stop AT %IX100.0 : BOOL := 0;
    Emergency AT %IX100.2 : BOOL;
    Working_LED AT %QX100.0 : BOOL;
    LED1 AT %QX100.1 : BOOL;
    LED2 AT %QX100.2 : BOOL;
    LED3 AT %QX100.3 : BOOL;
    LED4 AT %QX100.4 : BOOL;
    LED5 AT %QX100.5 : BOOL;
    LED6 AT %QX100.6 : BOOL;
  END_VAR
  VAR
    CTUD0 : CTUD;
    Run : BOOL;
    Run0 : BOOL;
    CV : INT := 5;
    CT : INT := 5;
    R_TRIG1 : R_TRIG;
    R_TRIG2 : R_TRIG;
    _TMP_EQ48_OUT : BOOL;
    _TMP_EQ49_OUT : BOOL;
    _TMP_OR59_OUT : BOOL;
    _TMP_EQ50_OUT : BOOL;
    _TMP_EQ51_OUT : BOOL;
    _TMP_OR61_OUT : BOOL;
    _TMP_EQ52_OUT : BOOL;
    _TMP_EQ53_OUT : BOOL;
    _TMP_OR63_OUT : BOOL;
    _TMP_EQ58_OUT : BOOL;
    _TMP_EQ57_OUT : BOOL;
    _TMP_OR60_OUT : BOOL;
    _TMP_EQ54_OUT : BOOL;
    _TMP_EQ56_OUT : BOOL;
    _TMP_OR62_OUT : BOOL;
    _TMP_EQ55_OUT : BOOL;
    _TMP_OR64_OUT : BOOL;
  END_VAR

  Run := NOT(Emergency) AND (Down OR Run OR Up);
  R_TRIG1(CLK := Up AND NOT(Run0));
  R_TRIG2(CLK := Down AND NOT(Run0));
  CTUD0(CU := R_TRIG1.Q, CD := R_TRIG2.Q, R := Emergency, PV := 12);
  _TMP_EQ48_OUT := EQ(1, CTUD0.CV);
  _TMP_EQ49_OUT := EQ(2, CTUD0.CV);
  _TMP_OR59_OUT := OR(_TMP_EQ48_OUT, _TMP_EQ49_OUT);
  LED1 := _TMP_OR59_OUT;
  _TMP_EQ50_OUT := EQ(3, CTUD0.CV);
  _TMP_EQ51_OUT := EQ(4, CTUD0.CV);
  _TMP_OR61_OUT := OR(_TMP_EQ49_OUT, _TMP_EQ50_OUT, _TMP_EQ51_OUT);
  LED2 := _TMP_OR61_OUT;
  _TMP_EQ52_OUT := EQ(5, CTUD0.CV);
  _TMP_EQ53_OUT := EQ(6, CTUD0.CV);
  _TMP_OR63_OUT := OR(_TMP_EQ51_OUT, _TMP_EQ52_OUT, _TMP_EQ53_OUT);
  LED3 := _TMP_OR63_OUT;
  _TMP_EQ58_OUT := EQ(7, CTUD0.CV);
  _TMP_EQ57_OUT := EQ(8, CTUD0.CV);
  _TMP_OR60_OUT := OR(_TMP_EQ53_OUT, _TMP_EQ58_OUT, _TMP_EQ57_OUT);
  LED4 := _TMP_OR60_OUT;
  _TMP_EQ54_OUT := EQ(9, CTUD0.CV);
  _TMP_EQ56_OUT := EQ(10, CTUD0.CV);
  _TMP_OR62_OUT := OR(_TMP_EQ57_OUT, _TMP_EQ54_OUT, _TMP_EQ56_OUT);
  LED5 := _TMP_OR62_OUT;
  _TMP_EQ55_OUT := EQ(11, CTUD0.CV);
  _TMP_OR64_OUT := OR(_TMP_EQ56_OUT, _TMP_EQ55_OUT);
  LED6 := _TMP_OR64_OUT;
  IF Stop AND Run0 THEN
    Run0 := FALSE; (*reset*)
  END_IF;
  IF Start AND Run THEN
    Run0 := TRUE; (*set*)
  END_IF;
  Working_LED := Run0;
  IF Emergency THEN
    Run0 := FALSE; (*reset*)
  END_IF;
END_PROGRAM


CONFIGURATION Config0

  RESOURCE Res0 ON PLC
    TASK mytask(INTERVAL := T#100ms,PRIORITY := 1);
    PROGRAM mainLogic WITH mytask : program0;
  END_RESOURCE
END_CONFIGURATION

(*DBG:char md5[] = "cf090fe78b94a5f35beecbc73f0a0989";*)
(*DBG:/**)
(*DBG: * This file is part of OpenPLC Runtime*)
(*DBG: **)
(*DBG: * Copyright (C) 2023 Autonomy, GP Orcullo*)
(*DBG: * Based on the work by GP Orcullo on Beremiz for uC*)
(*DBG: **)
(*DBG: * This program is free software; you can redistribute it and/or*)
(*DBG: * modify it under the terms of the GNU General Public License*)
(*DBG: * as published by the Free Software Foundation; either version 2*)
(*DBG: * of the License, or (at your option) any later version.*)
(*DBG: **)
(*DBG: * This program is distributed in the hope that it will be useful,*)
(*DBG: * but WITHOUT ANY WARRANTY; without even the implied warranty of*)
(*DBG: * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the*)
(*DBG: * GNU General Public License for more details.*)
(*DBG: **)
(*DBG: * You should have received a copy of the GNU General Public License*)
(*DBG: * along with this program; If not, see <http://www.gnu.org/licenses/>.*)
(*DBG: **)
(*DBG: */*)
(*DBG:*)
(*DBG:#include <stdbool.h>*)
(*DBG:*)
(*DBG:#include "iec_types_all.h"*)
(*DBG:#include "POUS.h"*)
(*DBG:*)
(*DBG:#define SAME_ENDIANNESS      0*)
(*DBG:#define REVERSE_ENDIANNESS   1*)
(*DBG:*)
(*DBG:uint8_t endianness;*)
(*DBG:*)
(*DBG:*)
(*DBG:extern PROGRAM0 RES0__MAINLOGIC;*)
(*DBG:*)
(*DBG:static const struct {*)
(*DBG:    void *ptr;*)
(*DBG:    __IEC_types_enum type;*)
(*DBG:} debug_vars[] = {*)
(*DBG:    {&(RES0__MAINLOGIC.UP), BOOL_ENUM},*)
(*DBG:    {&(RES0__MAINLOGIC.DOWN), BOOL_ENUM},*)
(*DBG:    {&(RES0__MAINLOGIC.START), BOOL_ENUM},*)
(*DBG:    {&(RES0__MAINLOGIC.STOP), BOOL_ENUM},*)
(*DBG:    {&(RES0__MAINLOGIC.EMERGENCY), BOOL_ENUM},*)
(*DBG:    {&(RES0__MAINLOGIC.WORKING_LED), BOOL_ENUM},*)
(*DBG:    {&(RES0__MAINLOGIC.LED1), BOOL_ENUM},*)
(*DBG:    {&(RES0__MAINLOGIC.LED2), BOOL_ENUM},*)
(*DBG:    {&(RES0__MAINLOGIC.LED3), BOOL_ENUM},*)
(*DBG:    {&(RES0__MAINLOGIC.LED4), BOOL_ENUM},*)
(*DBG:    {&(RES0__MAINLOGIC.LED5), BOOL_ENUM},*)
(*DBG:    {&(RES0__MAINLOGIC.LED6), BOOL_ENUM},*)
(*DBG:    {&(RES0__MAINLOGIC.CTUD0.EN), BOOL_ENUM},*)
(*DBG:    {&(RES0__MAINLOGIC.CTUD0.ENO), BOOL_ENUM},*)
(*DBG:    {&(RES0__MAINLOGIC.CTUD0.CU), BOOL_ENUM},*)
(*DBG:    {&(RES0__MAINLOGIC.CTUD0.CD), BOOL_ENUM},*)
(*DBG:    {&(RES0__MAINLOGIC.CTUD0.R), BOOL_ENUM},*)
(*DBG:    {&(RES0__MAINLOGIC.CTUD0.LD), BOOL_ENUM},*)
(*DBG:    {&(RES0__MAINLOGIC.CTUD0.PV), INT_ENUM},*)
(*DBG:    {&(RES0__MAINLOGIC.CTUD0.QU), BOOL_ENUM},*)
(*DBG:    {&(RES0__MAINLOGIC.CTUD0.QD), BOOL_ENUM},*)
(*DBG:    {&(RES0__MAINLOGIC.CTUD0.CV), INT_ENUM},*)
(*DBG:    {&(RES0__MAINLOGIC.CTUD0.CD_T.EN), BOOL_ENUM},*)
(*DBG:    {&(RES0__MAINLOGIC.CTUD0.CD_T.ENO), BOOL_ENUM},*)
(*DBG:    {&(RES0__MAINLOGIC.CTUD0.CD_T.CLK), BOOL_ENUM},*)
(*DBG:    {&(RES0__MAINLOGIC.CTUD0.CD_T.Q), BOOL_ENUM},*)
(*DBG:    {&(RES0__MAINLOGIC.CTUD0.CD_T.M), BOOL_ENUM},*)
(*DBG:    {&(RES0__MAINLOGIC.CTUD0.CU_T.EN), BOOL_ENUM},*)
(*DBG:    {&(RES0__MAINLOGIC.CTUD0.CU_T.ENO), BOOL_ENUM},*)
(*DBG:    {&(RES0__MAINLOGIC.CTUD0.CU_T.CLK), BOOL_ENUM},*)
(*DBG:    {&(RES0__MAINLOGIC.CTUD0.CU_T.Q), BOOL_ENUM},*)
(*DBG:    {&(RES0__MAINLOGIC.CTUD0.CU_T.M), BOOL_ENUM},*)
(*DBG:    {&(RES0__MAINLOGIC.RUN), BOOL_ENUM},*)
(*DBG:    {&(RES0__MAINLOGIC.RUN0), BOOL_ENUM},*)
(*DBG:    {&(RES0__MAINLOGIC.CV), INT_ENUM},*)
(*DBG:    {&(RES0__MAINLOGIC.CT), INT_ENUM},*)
(*DBG:    {&(RES0__MAINLOGIC.R_TRIG1.EN), BOOL_ENUM},*)
(*DBG:    {&(RES0__MAINLOGIC.R_TRIG1.ENO), BOOL_ENUM},*)
(*DBG:    {&(RES0__MAINLOGIC.R_TRIG1.CLK), BOOL_ENUM},*)
(*DBG:    {&(RES0__MAINLOGIC.R_TRIG1.Q), BOOL_ENUM},*)
(*DBG:    {&(RES0__MAINLOGIC.R_TRIG1.M), BOOL_ENUM},*)
(*DBG:    {&(RES0__MAINLOGIC.R_TRIG2.EN), BOOL_ENUM},*)
(*DBG:    {&(RES0__MAINLOGIC.R_TRIG2.ENO), BOOL_ENUM},*)
(*DBG:    {&(RES0__MAINLOGIC.R_TRIG2.CLK), BOOL_ENUM},*)
(*DBG:    {&(RES0__MAINLOGIC.R_TRIG2.Q), BOOL_ENUM},*)
(*DBG:    {&(RES0__MAINLOGIC.R_TRIG2.M), BOOL_ENUM},*)
(*DBG:    {&(RES0__MAINLOGIC._TMP_EQ48_OUT), BOOL_ENUM},*)
(*DBG:    {&(RES0__MAINLOGIC._TMP_EQ49_OUT), BOOL_ENUM},*)
(*DBG:    {&(RES0__MAINLOGIC._TMP_OR59_OUT), BOOL_ENUM},*)
(*DBG:    {&(RES0__MAINLOGIC._TMP_EQ50_OUT), BOOL_ENUM},*)
(*DBG:    {&(RES0__MAINLOGIC._TMP_EQ51_OUT), BOOL_ENUM},*)
(*DBG:    {&(RES0__MAINLOGIC._TMP_OR61_OUT), BOOL_ENUM},*)
(*DBG:    {&(RES0__MAINLOGIC._TMP_EQ52_OUT), BOOL_ENUM},*)
(*DBG:    {&(RES0__MAINLOGIC._TMP_EQ53_OUT), BOOL_ENUM},*)
(*DBG:    {&(RES0__MAINLOGIC._TMP_OR63_OUT), BOOL_ENUM},*)
(*DBG:    {&(RES0__MAINLOGIC._TMP_EQ58_OUT), BOOL_ENUM},*)
(*DBG:    {&(RES0__MAINLOGIC._TMP_EQ57_OUT), BOOL_ENUM},*)
(*DBG:    {&(RES0__MAINLOGIC._TMP_OR60_OUT), BOOL_ENUM},*)
(*DBG:    {&(RES0__MAINLOGIC._TMP_EQ54_OUT), BOOL_ENUM},*)
(*DBG:    {&(RES0__MAINLOGIC._TMP_EQ56_OUT), BOOL_ENUM},*)
(*DBG:    {&(RES0__MAINLOGIC._TMP_OR62_OUT), BOOL_ENUM},*)
(*DBG:    {&(RES0__MAINLOGIC._TMP_EQ55_OUT), BOOL_ENUM},*)
(*DBG:    {&(RES0__MAINLOGIC._TMP_OR64_OUT), BOOL_ENUM},*)
(*DBG:};*)
(*DBG:*)
(*DBG:#define VAR_COUNT               63*)
(*DBG:*)
(*DBG:uint16_t get_var_count(void)*)
(*DBG:{*)
(*DBG:    return VAR_COUNT;*)
(*DBG:}*)
(*DBG:*)
(*DBG:size_t get_var_size(size_t idx)*)
(*DBG:{*)
(*DBG:    if (idx >= VAR_COUNT)*)
(*DBG:    {*)
(*DBG:        return 0;*)
(*DBG:    }*)
(*DBG:    switch (debug_vars[idx].type) {*)
(*DBG:    case BOOL_ENUM:*)
(*DBG:        return sizeof(BOOL);*)
(*DBG:    case INT_ENUM:*)
(*DBG:        return sizeof(INT);*)
(*DBG:    default:*)
(*DBG:        return 0;*)
(*DBG:    }*)
(*DBG:}*)
(*DBG:*)
(*DBG:void *get_var_addr(size_t idx)*)
(*DBG:{*)
(*DBG:    void *ptr = debug_vars[idx].ptr;*)
(*DBG:*)
(*DBG:    switch (debug_vars[idx].type) {*)
(*DBG:    case BOOL_ENUM:*)
(*DBG:        return (void *)&((__IEC_BOOL_t *) ptr)->value;*)
(*DBG:    case INT_ENUM:*)
(*DBG:        return (void *)&((__IEC_INT_t *) ptr)->value;*)
(*DBG:    default:*)
(*DBG:        return 0;*)
(*DBG:    }*)
(*DBG:}*)
(*DBG:*)
(*DBG:void force_var(size_t idx, bool forced, void *val)*)
(*DBG:{*)
(*DBG:    void *ptr = debug_vars[idx].ptr;*)
(*DBG:*)
(*DBG:    if (forced) {*)
(*DBG:        size_t var_size = get_var_size(idx);*)
(*DBG:        switch (debug_vars[idx].type) {*)
(*DBG:        case BOOL_ENUM: {*)
(*DBG:            memcpy(&((__IEC_BOOL_t *) ptr)->value, val, var_size);*)
(*DBG:            //((__IEC_BOOL_t *) ptr)->value = *((BOOL *) val);*)
(*DBG:            ((__IEC_BOOL_t *) ptr)->flags |= __IEC_FORCE_FLAG;*)
(*DBG:            break;*)
(*DBG:        }*)
(*DBG:        case INT_ENUM: {*)
(*DBG:            memcpy(&((__IEC_INT_t *) ptr)->value, val, var_size);*)
(*DBG:            //((__IEC_INT_t *) ptr)->value = *((INT *) val);*)
(*DBG:            ((__IEC_INT_t *) ptr)->flags |= __IEC_FORCE_FLAG;*)
(*DBG:            break;*)
(*DBG:        }*)
(*DBG:        default:*)
(*DBG:            break;*)
(*DBG:        }*)
(*DBG:    } else {*)
(*DBG:        switch (debug_vars[idx].type) {*)
(*DBG:        case BOOL_ENUM:*)
(*DBG:            ((__IEC_BOOL_t *) ptr)->flags &= ~__IEC_FORCE_FLAG;*)
(*DBG:            break;*)
(*DBG:        case INT_ENUM:*)
(*DBG:            ((__IEC_INT_t *) ptr)->flags &= ~__IEC_FORCE_FLAG;*)
(*DBG:            break;*)
(*DBG:        default:*)
(*DBG:            break;*)
(*DBG:        }*)
(*DBG:    }*)
(*DBG:}*)
(*DBG:*)
(*DBG:void swap_bytes(void *ptr, size_t size) *)
(*DBG:{*)
(*DBG:    uint8_t *bytePtr = (uint8_t *)ptr;*)
(*DBG:    size_t i;*)
(*DBG:    for (i = 0; i < size / 2; ++i) *)
(*DBG:    {*)
(*DBG:        uint8_t temp = bytePtr[i];*)
(*DBG:        bytePtr[i] = bytePtr[size - 1 - i];*)
(*DBG:        bytePtr[size - 1 - i] = temp;*)
(*DBG:    }*)
(*DBG:}*)
(*DBG:*)
(*DBG:void trace_reset(void)*)
(*DBG:{*)
(*DBG:    for (size_t i=0; i < VAR_COUNT; i++) *)
(*DBG:    {*)
(*DBG:        force_var(i, false, 0);*)
(*DBG:    }*)
(*DBG:}*)
(*DBG:*)
(*DBG:void set_trace(size_t idx, bool forced, void *val)*)
(*DBG:{*)
(*DBG:    if (idx >= 0 && idx < VAR_COUNT) *)
(*DBG:    {*)
(*DBG:        if (endianness == REVERSE_ENDIANNESS)*)
(*DBG:        {*)
(*DBG:            // Aaaaarghhhh... Stupid AVR is Big Endian.*)
(*DBG:            swap_bytes(val, get_var_size(idx));*)
(*DBG:        }*)
(*DBG:*)
(*DBG:        force_var(idx, forced, val);*)
(*DBG:    }*)
(*DBG:}*)
(*DBG:*)
(*DBG:void set_endianness(uint8_t value)*)
(*DBG:{*)
(*DBG:    if (value == SAME_ENDIANNESS || value == REVERSE_ENDIANNESS)*)
(*DBG:    {*)
(*DBG:        endianness = value;*)
(*DBG:    }*)
(*DBG:}*)
(*DBG:*)