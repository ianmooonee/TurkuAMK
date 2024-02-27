/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * File: Filter0.c
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

#include "Filter0.h"
#include "rtwtypes.h"
#ifndef UCHAR_MAX
#include <limits.h>
#endif

#if ( UCHAR_MAX != (0xFFU) ) || ( SCHAR_MAX != (0x7F) )
#error Code was generated for compiler with different sized uchar/char. \
Consider adjusting Test hardware word size settings on the \
Hardware Implementation pane to match your compiler word sizes as \
defined in limits.h of the compiler. Alternatively, you can \
select the Test hardware is the same as production hardware option and \
select the Enable portable word sizes option on the Code Generation > \
Verification pane for ERT based targets, which will disable the \
preprocessor word size checks.
#endif

#if ( USHRT_MAX != (0xFFFFU) ) || ( SHRT_MAX != (0x7FFF) )
#error Code was generated for compiler with different sized ushort/short. \
Consider adjusting Test hardware word size settings on the \
Hardware Implementation pane to match your compiler word sizes as \
defined in limits.h of the compiler. Alternatively, you can \
select the Test hardware is the same as production hardware option and \
select the Enable portable word sizes option on the Code Generation > \
Verification pane for ERT based targets, which will disable the \
preprocessor word size checks.
#endif

#if ( UINT_MAX != (0xFFFFFFFFU) ) || ( INT_MAX != (0x7FFFFFFF) )
#error Code was generated for compiler with different sized uint/int. \
Consider adjusting Test hardware word size settings on the \
Hardware Implementation pane to match your compiler word sizes as \
defined in limits.h of the compiler. Alternatively, you can \
select the Test hardware is the same as production hardware option and \
select the Enable portable word sizes option on the Code Generation > \
Verification pane for ERT based targets, which will disable the \
preprocessor word size checks.
#endif

/* Skipping ulong/long check: insufficient preprocessor integer range. */

/* Skipping ulong_long/long_long check: insufficient preprocessor integer range. */

/* Block signals and states (default storage) */
DW rtDW;

/* External inputs (root inport signals with default storage) */
ExtU rtU;

/* External outputs (root outports fed by signals with default storage) */
ExtY rtY;

/* Model step function */
void Filter0_step(void)
{
  int64_T acc1;
  int32_T n;
  int32_T tmp;
  int16_T zNext;

  /* DiscreteFir: '<S1>/filter' incorporates:
   *  Inport: '<Root>/In'
   */
  acc1 = 0L;

  /* load input sample */
  zNext = rtU.In;
  for (n = 0; n < 50; n++) {
    int16_T zCurr;

    /* shift state */
    zCurr = zNext;
    zNext = rtDW.filter_states[n];
    rtDW.filter_states[n] = zCurr;

    /* compute one tap */
    tmp = rtConstP.filter_Coefficients[n] * zCurr;
    if (tmp > 1073741823) {
      tmp = 1073741823;
    }

    acc1 += tmp;
    if (acc1 > 549755813887L) {
      acc1 = 549755813887L;
    } else if (acc1 < -549755813888L) {
      acc1 = -549755813888L;
    }
  }

  /* compute last tap */
  /* store output sample */
  tmp = rtConstP.filter_Coefficients[n] * zNext;
  if (tmp > 1073741823) {
    tmp = 1073741823;
  }

  acc1 += tmp;
  if (acc1 > 549755813887L) {
    acc1 = 549755813887L;
  } else if (acc1 < -549755813888L) {
    acc1 = -549755813888L;
  }

  if (acc1 > 32767L) {
    acc1 = 32767L;
  } else if (acc1 < -32768L) {
    acc1 = -32768L;
  }

  /* Outport: '<Root>/Out' incorporates:
   *  DiscreteFir: '<S1>/filter'
   */
  rtY.Out = (int16_T)acc1;
}

/* Model initialize function */
void Filter0_initialize(void)
{
  /* (no initialization code required) */
}

/*
 * File trailer for generated code.
 *
 * [EOF]
 */
