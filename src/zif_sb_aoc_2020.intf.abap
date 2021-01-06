interface ZIF_SB_AOC_2020
  public .


  types TY_INPUT type STRING .
  types:
    tt_input TYPE TABLE OF ty_input .

  class-methods SOLVE
    importing
      !IT_INPUT type TT_INPUT
    returning
      value(RV_OUTPUT) type STRING .
endinterface.
