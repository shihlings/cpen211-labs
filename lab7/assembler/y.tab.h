#ifndef _yy_defines_h_
#define _yy_defines_h_

#define DOT_ORG 257
#define DOT_SECTION 258
#define DOT_TEXT 259
#define DOT_DATA 260
#define DOT_WORD 261
#define DOT_EQU 262
#define DOT_GLOBAL 263
#define B 264
#define BEQ 265
#define BNE 266
#define BLT 267
#define BLE 268
#define BL 269
#define BLX 270
#define BX 271
#define LDR 272
#define STR 273
#define ADD 274
#define AND 275
#define CMP 276
#define MVN 277
#define MOV 278
#define LSL 279
#define LSR 280
#define ASR 281
#define NOP 282
#define HALT 283
#define DLLR 284
#define NUMB 285
#define PERC 286
#define NEW_LINE 287
#define REGISTER 288
#define REG_LR 289
#define LABEL 290
#define LABEL_DEF 291
#define DEC_NUMBER 292
#define BIN_NUMBER 293
#define HEX_NUMBER 294
#ifdef YYSTYPE
#undef  YYSTYPE_IS_DECLARED
#define YYSTYPE_IS_DECLARED 1
#endif
#ifndef YYSTYPE_IS_DECLARED
#define YYSTYPE_IS_DECLARED 1
typedef union YYSTYPE {
  int   integer_value;
  float float_value;
  char *string_value;
} YYSTYPE;
#endif /* !YYSTYPE_IS_DECLARED */
extern YYSTYPE yylval;

#endif /* _yy_defines_h_ */
