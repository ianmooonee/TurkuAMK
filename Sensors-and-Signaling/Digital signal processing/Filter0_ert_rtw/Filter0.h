/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * File: Filter0.h
 *
 * Code generated for Simulink model 'Filter0'.
 *
 * Model version                  : 1.1
 * Simulink Coder version         : 9.8 (R2022b) 13-May-2022
 * C/C++ source code generated on : Wed Oct 11 13:48:44 2023
 *
 * Target selection: ert.tlc
 * Embedded hardware selection: Intel->x86-64 (Mac OS X)
 * Code generation objectives:
 *    1. Execution efficiency
 *    2. RAM efficiency
 * Validation result: Not run
 */

#ifndef RTW_HEADER_Filter0_h_
#define RTW_HEADER_Filter0_h_
#ifndef Filter0_COMMON_INCLUDES_
#define Filter0_COMMON_INCLUDES_
#include "rtwtypes.h"
#endif                                 /* Filter0_COMMON_INCLUDES_ */

/* Block signals and states (default storage) for system '<Root>' */
typedef struct {
  int16_T filter_states[50];           /* '<S1>/filter' */
} DW;

/* Constant parameters (default storage) */
typedef struct {
  /* Computed Parameter: filter_Coefficients
   * Referenced by: '<S1>/filter'
   */
  int16_T filter_Coefficients[51];
} ConstP;

/* External inputs (root inport signals with default storage) */
typedef struct {
  int16_T In;                          /* '<Root>/In' */
} ExtU;

/* External outputs (root outports fed by signals with default storage) */
typedef struct {
  int16_T Out;                         /* '<Root>/Out' */
} ExtY;

/* Block signals and states (default storage) */
extern DW rtDW;

/* External inputs (root inport signals with default storage) */
extern ExtU rtU;

/* External outputs (root outports fed by signals with default storage) */
extern ExtY rtY;

/* Constant parameters (default storage) */
extern const ConstP rtConstP;

/* Model entry point functions */
extern void Filter0_initialize(void);
extern void Filter0_step(void);

/*-
 * These blocks were eliminated from the model due to optimizations:
 *
 * Block '<S1>/Input Quantizer' : Eliminate redundant data type conversion
 */

/*-
 * The generated code includes comments that allow you to trace directly
 * back to the appropriate location in the model.  The basic format
 * is <system>/block_name, where system is the system number (uniquely
 * assigned by Simulink) and block_name is the name of the block.
 *
 * Note that this particular code originates from a subsystem build,
 * and has its own system numbers different from the parent model.
 * Refer to the system hierarchy for this subsystem below, and use the
 * MATLAB hilite_system command to trace the generated code back
 * to the parent model.  For example,
 *
 * hilite_system('digital_filter_implementation/Filter')    - opens subsystem digital_filter_implementation/Filter
 * hilite_system('digital_filter_implementation/Filter/Kp') - opens and selects block Kp
 *
 * Here is the system hierarchy for this model
 *
 * '<Root>' : 'digital_filter_implementation'
 * '<S1>'   : 'digital_filter_implementation/Filter'
 */
#endif                                 /* RTW_HEADER_Filter0_h_ */

/*
 * File trailer for generated code.
 *
 * [EOF]
 */
