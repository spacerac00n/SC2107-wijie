################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Each subdirectory must supply rules for building sources it contributes
ADC14.obj: /Users/grassjelly/Desktop/SC2107/inc/ADC14.c $(GEN_OPTS) | $(GEN_FILES) $(GEN_MISC_FILES)
	@echo 'MSP432 Compiler - building file: "$<"'
	"" -mv7M4 --code_state=16 --float_support=FPv4SPD16 -me --include_path="/Applications/ti/ccs2101/ccs/ccs_base/arm/include" --include_path="/Applications/ti/ccs2101/ccs/ccs_base/arm/include/CMSIS" --include_path="/Users/grassjelly/Desktop/SC2107/Lab4_ADC_IRSensors" --include_path="/include" --advice:power=all --define=__MSP432P401R__ --define=TARGET_IS_MSP432P4XX --define=ccs -g --gcc --diag_warning=225 --diag_wrap=off --display_error_number --abi=eabi --preproc_with_compile --preproc_dependency="$(basename $(<F)).d_raw" $(GEN_OPTS__FLAG) "$<"
	@echo 'Finished building: "$<"'
	@echo ' '

Clock.obj: /Users/grassjelly/Desktop/SC2107/inc/Clock.c $(GEN_OPTS) | $(GEN_FILES) $(GEN_MISC_FILES)
	@echo 'MSP432 Compiler - building file: "$<"'
	"" -mv7M4 --code_state=16 --float_support=FPv4SPD16 -me --include_path="/Applications/ti/ccs2101/ccs/ccs_base/arm/include" --include_path="/Applications/ti/ccs2101/ccs/ccs_base/arm/include/CMSIS" --include_path="/Users/grassjelly/Desktop/SC2107/Lab4_ADC_IRSensors" --include_path="/include" --advice:power=all --define=__MSP432P401R__ --define=TARGET_IS_MSP432P4XX --define=ccs -g --gcc --diag_warning=225 --diag_wrap=off --display_error_number --abi=eabi --preproc_with_compile --preproc_dependency="$(basename $(<F)).d_raw" $(GEN_OPTS__FLAG) "$<"
	@echo 'Finished building: "$<"'
	@echo ' '

CortexM.obj: /Users/grassjelly/Desktop/SC2107/inc/CortexM.c $(GEN_OPTS) | $(GEN_FILES) $(GEN_MISC_FILES)
	@echo 'MSP432 Compiler - building file: "$<"'
	"" -mv7M4 --code_state=16 --float_support=FPv4SPD16 -me --include_path="/Applications/ti/ccs2101/ccs/ccs_base/arm/include" --include_path="/Applications/ti/ccs2101/ccs/ccs_base/arm/include/CMSIS" --include_path="/Users/grassjelly/Desktop/SC2107/Lab4_ADC_IRSensors" --include_path="/include" --advice:power=all --define=__MSP432P401R__ --define=TARGET_IS_MSP432P4XX --define=ccs -g --gcc --diag_warning=225 --diag_wrap=off --display_error_number --abi=eabi --preproc_with_compile --preproc_dependency="$(basename $(<F)).d_raw" $(GEN_OPTS__FLAG) "$<"
	@echo 'Finished building: "$<"'
	@echo ' '

IRDistance.obj: /Users/grassjelly/Desktop/SC2107/inc/IRDistance.c $(GEN_OPTS) | $(GEN_FILES) $(GEN_MISC_FILES)
	@echo 'MSP432 Compiler - building file: "$<"'
	"" -mv7M4 --code_state=16 --float_support=FPv4SPD16 -me --include_path="/Applications/ti/ccs2101/ccs/ccs_base/arm/include" --include_path="/Applications/ti/ccs2101/ccs/ccs_base/arm/include/CMSIS" --include_path="/Users/grassjelly/Desktop/SC2107/Lab4_ADC_IRSensors" --include_path="/include" --advice:power=all --define=__MSP432P401R__ --define=TARGET_IS_MSP432P4XX --define=ccs -g --gcc --diag_warning=225 --diag_wrap=off --display_error_number --abi=eabi --preproc_with_compile --preproc_dependency="$(basename $(<F)).d_raw" $(GEN_OPTS__FLAG) "$<"
	@echo 'Finished building: "$<"'
	@echo ' '

LPF.obj: /Users/grassjelly/Desktop/SC2107/inc/LPF.c $(GEN_OPTS) | $(GEN_FILES) $(GEN_MISC_FILES)
	@echo 'MSP432 Compiler - building file: "$<"'
	"" -mv7M4 --code_state=16 --float_support=FPv4SPD16 -me --include_path="/Applications/ti/ccs2101/ccs/ccs_base/arm/include" --include_path="/Applications/ti/ccs2101/ccs/ccs_base/arm/include/CMSIS" --include_path="/Users/grassjelly/Desktop/SC2107/Lab4_ADC_IRSensors" --include_path="/include" --advice:power=all --define=__MSP432P401R__ --define=TARGET_IS_MSP432P4XX --define=ccs -g --gcc --diag_warning=225 --diag_wrap=off --display_error_number --abi=eabi --preproc_with_compile --preproc_dependency="$(basename $(<F)).d_raw" $(GEN_OPTS__FLAG) "$<"
	@echo 'Finished building: "$<"'
	@echo ' '

%.obj: ../%.c $(GEN_OPTS) | $(GEN_FILES) $(GEN_MISC_FILES)
	@echo 'MSP432 Compiler - building file: "$<"'
	"" -mv7M4 --code_state=16 --float_support=FPv4SPD16 -me --include_path="/Applications/ti/ccs2101/ccs/ccs_base/arm/include" --include_path="/Applications/ti/ccs2101/ccs/ccs_base/arm/include/CMSIS" --include_path="/Users/grassjelly/Desktop/SC2107/Lab4_ADC_IRSensors" --include_path="/include" --advice:power=all --define=__MSP432P401R__ --define=TARGET_IS_MSP432P4XX --define=ccs -g --gcc --diag_warning=225 --diag_wrap=off --display_error_number --abi=eabi --preproc_with_compile --preproc_dependency="$(basename $(<F)).d_raw" $(GEN_OPTS__FLAG) "$<"
	@echo 'Finished building: "$<"'
	@echo ' '

LaunchPad.obj: /Users/grassjelly/Desktop/SC2107/inc/LaunchPad.c $(GEN_OPTS) | $(GEN_FILES) $(GEN_MISC_FILES)
	@echo 'MSP432 Compiler - building file: "$<"'
	"" -mv7M4 --code_state=16 --float_support=FPv4SPD16 -me --include_path="/Applications/ti/ccs2101/ccs/ccs_base/arm/include" --include_path="/Applications/ti/ccs2101/ccs/ccs_base/arm/include/CMSIS" --include_path="/Users/grassjelly/Desktop/SC2107/Lab4_ADC_IRSensors" --include_path="/include" --advice:power=all --define=__MSP432P401R__ --define=TARGET_IS_MSP432P4XX --define=ccs -g --gcc --diag_warning=225 --diag_wrap=off --display_error_number --abi=eabi --preproc_with_compile --preproc_dependency="$(basename $(<F)).d_raw" $(GEN_OPTS__FLAG) "$<"
	@echo 'Finished building: "$<"'
	@echo ' '

TimerA1.obj: /Users/grassjelly/Desktop/SC2107/inc/TimerA1.c $(GEN_OPTS) | $(GEN_FILES) $(GEN_MISC_FILES)
	@echo 'MSP432 Compiler - building file: "$<"'
	"" -mv7M4 --code_state=16 --float_support=FPv4SPD16 -me --include_path="/Applications/ti/ccs2101/ccs/ccs_base/arm/include" --include_path="/Applications/ti/ccs2101/ccs/ccs_base/arm/include/CMSIS" --include_path="/Users/grassjelly/Desktop/SC2107/Lab4_ADC_IRSensors" --include_path="/include" --advice:power=all --define=__MSP432P401R__ --define=TARGET_IS_MSP432P4XX --define=ccs -g --gcc --diag_warning=225 --diag_wrap=off --display_error_number --abi=eabi --preproc_with_compile --preproc_dependency="$(basename $(<F)).d_raw" $(GEN_OPTS__FLAG) "$<"
	@echo 'Finished building: "$<"'
	@echo ' '

UART0.obj: /Users/grassjelly/Desktop/SC2107/inc/UART0.c $(GEN_OPTS) | $(GEN_FILES) $(GEN_MISC_FILES)
	@echo 'MSP432 Compiler - building file: "$<"'
	"" -mv7M4 --code_state=16 --float_support=FPv4SPD16 -me --include_path="/Applications/ti/ccs2101/ccs/ccs_base/arm/include" --include_path="/Applications/ti/ccs2101/ccs/ccs_base/arm/include/CMSIS" --include_path="/Users/grassjelly/Desktop/SC2107/Lab4_ADC_IRSensors" --include_path="/include" --advice:power=all --define=__MSP432P401R__ --define=TARGET_IS_MSP432P4XX --define=ccs -g --gcc --diag_warning=225 --diag_wrap=off --display_error_number --abi=eabi --preproc_with_compile --preproc_dependency="$(basename $(<F)).d_raw" $(GEN_OPTS__FLAG) "$<"
	@echo 'Finished building: "$<"'
	@echo ' '


