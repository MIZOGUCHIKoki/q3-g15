.include "common.h"
.section .text
.global sound_2
sound_2:
push  {r0-r12,r14}
bl    settings

  ldr r0 , =TIMER_BASE  @変更しない
  ldr r12, =PWM_BASE    @変更しない
  ldr r1 , =time       @目標時刻いじる際に使用
  ldr r2 , [r0, #GPFSEL1]@現在時刻
  ldr r3 , =melody      @変更しない
  ldr r4 , =rhythm      @変更しない
  ldr r5 , =sound_data  @変更しない
  ldr r6 , =rhythm_data @変更しない
  ldr r7 , =count       @変更しない
@using register --r0,r1,r2,r3,r4,r5,r6,r7
@r8は目標時刻の更新に使用する
@r9鳴らしたい音を持つレジスタ
@r10鳴らしたいリズムを持つレジスタ
@r11countの数ldr,strする用

  ldr r8 , [r1]   @音を鳴らす目標時刻をldr
@音を鳴らす時刻かどうかを確認
  cmp r2 , r8     @r2のが大の時,音を鳴らす
  ldrcs r11 , [r7] 
  ldrcs r9 , [r3, r11, lsr #2]  
  ldrcs r10, [r4, r11, lsr #2]
  ldrcs r9 , [r5, r9 , lsr #2]
  ldrcs r10, [r6, r10, lsr #2]
  addcs r11, r11, #1  @count更新
  strcs r11, [r7]     @count更新後データstr
    
  @音を鳴らす
  strcs r9 , [r12, #PWM_RNG2]
  lsrcs r9 , r9, #1   @デゥーティー比を1/2
  strcs r9 , [r12, #PWM_DAT2]
 @r0-r8,r10,r12は変更禁止 
  addcs r9 , r8, r10
  strcs r9 , [r1, #0]   @音符の長さ
  movcs r10, r10, lsr #1@実際になっている時間 
  addcs r9 , r8, r10    
  strcs r9 , [r1, #4]   
 
 @r0-r7,r12
  ldr   r8 , [r1, #4]   @消す時刻かどうか
  ldr   r2 , [r0, #GPFSEL1]
  cmp   r2 , r8   @r2のが大きい時音を消す
  movcs r9 , #0
  strcs r9 , [r12, #PWM_DAT2]

  pop {r0-r12, r14}
  bx  r14
  .section .data
  .global count
count:
  @次に鳴らしたい音.(melodyの数字)
  @現在の鳴らしている音を外部から管理する用
  .word 0
time:
@音を鳴らす目標時刻,音を消す目標時刻
  .word 0xf4240, 0x0
melody:
@鳴らしたい音を数字にする
	.word 2,2,7,9,11,12,14,19,18,16,16,14,13,13,16,14,11
rhythm:
@鳴らしたいリズムを数字にする
@符号
	.word 5,3,1,1,1,1,1,0,5,3,4,1,2,2,2,1,1
sound_data:
@音データ.下のファから上のミ
	.word 27428, 25945, 24489, 23132, 21818, 200600, 19472, 18355, 17328, 16354, 15434, 14567, 13753, 12972
rhythm_data:
@リズムデータ
@2分音符, 4分音符,  8分音符,16分音符,付点4分音符,付点8分音符
	.word 1200000 ,600000   , 300000 , 150000 ,900000  ,450000 @ドラクエ