class ZCL_SB_AOC_2020_D1 definition
  public
  final
  create public .

public section.

  interfaces ZIF_SB_AOC_2020 .
protected section.
private section.
ENDCLASS.



CLASS ZCL_SB_AOC_2020_D1 IMPLEMENTATION.


  METHOD zif_sb_aoc_2020~solve.


    DATA(lt_input_tmp) = it_input[].

    LOOP AT it_input INTO DATA(ls_input).
      DATA(lv_index) = sy-tabix.
      lv_index = lv_index + 1.
      LOOP AT lt_input_tmp INTO DATA(ls_input_tmp) FROM lv_index.
        DATA(lv_sum) = ls_input + ls_input_tmp.
        IF lv_sum = '2020'.
          rv_output = ls_input * ls_input_tmp.
          RETURN.
        ENDIF.
      ENDLOOP.
    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
