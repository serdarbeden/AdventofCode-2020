*&---------------------------------------------------------------------*
*& Include          ZSB_AOC_2020_CLS
*&---------------------------------------------------------------------*
CLASS lcl_main DEFINITION.

  PUBLIC SECTION.
    DATA gv_day TYPE int4.
    METHODS:
      at_sel_screen_out,
      at_sel_screen_on IMPORTING VALUE(iv_par) TYPE string,
      start RETURNING VALUE(rv_output) TYPE string.
  PRIVATE SECTION.

ENDCLASS.

CLASS lcl_main IMPLEMENTATION.
  METHOD at_sel_screen_out.

    CALL FUNCTION 'VRM_SET_VALUES'
      EXPORTING
        id     = CONV vrm_id( 'P_DAY' )
        values = VALUE vrm_values(
                   FOR i = 1 UNTIL i > 30
                   ( key = i text = |Day { i }| ) ).

  ENDMETHOD.
  METHOD at_sel_screen_on.

    DATA lt_dynpread TYPE STANDARD TABLE OF dynpread.

    lt_dynpread = VALUE #( ( fieldname = iv_par ) ).

    CALL FUNCTION 'DYNP_VALUES_READ'
      EXPORTING
        dyname             = sy-cprog
        dynumb             = sy-dynnr
        translate_to_upper = 'X'
      TABLES
        dynpfields         = lt_dynpread.

    IF line_exists( lt_dynpread[ 1 ] ).
      DATA(ls_dynpread) = lt_dynpread[ 1 ].
      gv_day = ls_dynpread-fieldvalue.
    ENDIF.

  ENDMETHOD.
  METHOD start.
    DATA lt_filetable TYPE filetable.
    DATA lv_rc TYPE i.
    DATA lt_data TYPE TABLE OF string.
    DATA lv_filename TYPE string.
    DATA lo_container TYPE REF TO object.
    DATA exc_ref TYPE REF TO cx_root.
    DATA exc_text TYPE string.

    CALL METHOD cl_gui_frontend_services=>file_open_dialog
      EXPORTING
        window_title            = 'Choose input file as .txt'
      CHANGING
        file_table              = lt_filetable
        rc                      = lv_rc
      EXCEPTIONS
        file_open_dialog_failed = 1
        cntl_error              = 2
        error_no_gui            = 3
        not_supported_by_gui    = 4
        OTHERS                  = 5.


    IF line_exists( lt_filetable[ 1 ] ).
      DATA(ls_filetable) = lt_filetable[ 1 ].

      lv_filename = ls_filetable-filename.

      CALL METHOD cl_gui_frontend_services=>gui_upload
        EXPORTING
          filename                = lv_filename
        CHANGING
          data_tab                = lt_data
        EXCEPTIONS
          file_open_error         = 1
          file_read_error         = 2
          no_batch                = 3
          gui_refuse_filetransfer = 4
          invalid_type            = 5
          no_authority            = 6
          unknown_error           = 7
          bad_data_format         = 8
          header_not_allowed      = 9
          separator_not_allowed   = 10
          header_too_long         = 11
          unknown_dp_error        = 12
          access_denied           = 13
          dp_out_of_memory        = 14
          disk_full               = 15
          dp_timeout              = 16
          not_supported_by_gui    = 17
          error_no_gui            = 18
          OTHERS                  = 19.

      IF lt_data IS NOT INITIAL.
        DATA(lv_cls) = 'ZCL_SB_AOC_2020_D' && gv_day.
        DATA(lv_mtd) = 'ZIF_SB_AOC_2020~SOLVE'.

        TRY.
            CREATE OBJECT lo_container TYPE (lv_cls).
          CATCH cx_sy_create_object_error INTO exc_ref.
            exc_text = exc_ref->get_text( ).
        ENDTRY.

        TRY.
            CALL METHOD lo_container->(lv_mtd)
              EXPORTING
                it_input  = lt_data
              RECEIVING
                rv_output = rv_output.
          CATCH cx_ai_system_fault INTO exc_ref .
            exc_text = exc_ref->get_text( ).
        ENDTRY.
      ENDIF.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
