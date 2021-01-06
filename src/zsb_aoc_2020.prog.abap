*&---------------------------------------------------------------------*
*& Report ZSB_AOC_2020
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zsb_aoc_2020.

CLASS lcl_main DEFINITION DEFERRED.

PARAMETERS p_day TYPE i AS LISTBOX VISIBLE LENGTH 10 DEFAULT 1 OBLIGATORY.

INCLUDE zsb_aoc_2020_cls.

INITIALIZATION.
  DATA(go_main) = NEW lcl_main( ).

AT SELECTION-SCREEN OUTPUT.
  go_main->at_sel_screen_out( ).

AT SELECTION-SCREEN ON p_day.
  go_main->at_sel_screen_on( iv_par = 'P_DAY' ).

START-OF-SELECTION.

  DATA(gv_output) = go_main->start( ).

END-OF-SELECTION.
  WRITE:/ |{ 'Day' } { p_day } { 'result' }: { gv_output } |.
