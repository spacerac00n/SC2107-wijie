################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Each subdirectory must supply rules for building sources it contributes
Bump.obj: /Users/grassjelly/Desktop/SC2107/inc/Bump.c $(GEN_OPTS) | $(GEN_FILES) $(GEN_MISC_FILES)
	@echo 'MSP432 Compiler - building file: "$<"'
	"" -mv7M4 --code_state=16 --float_support=FPv4SPD16 -me --include_path="/Applications/ti/ccs2101/ccs/ccs_base/arm/include" --include_path="/Applications/ti/ccs2101/ccs/ccs_base/arm/include/CMSIS" --include_path="/Users/grassjelly/Desktop/SC2107/Lab3ref_SimpleMotors" --include_path="/include" --advice:power=all --define=__MSP432P401R__ --define=TARGET_IS_MSP432P4XX --define=ccs -g --gcc --diag_warning=225 --diag_wrap=off --display_error_number --abi=eabi --preproc_with_compile --preproc_dependency="$(basename $(<F)).d_raw" $(GEN_OPTS__FLAG) "$<"
	@echo 'Finished building: "$<"'
	@echo ' '

Clock.obj: /Users/grassjelly/Desktop/SC2107/inc/Clock.c $(GEN_OPTS) | $(GEN_FILES) $(GEN_MISC_FILES)
	@echo 'MSP432 Compiler - building file: "$<"'
	"" -mv7M4 --code_state=16 --float_support=FPv4SPD16 -me --include_path="/Applications/ti/ccs2101/ccs/ccs_base/arm/include" --include_path="/Applications/ti/ccs2101/ccs/ccs_base/arm/include/CMSIS" --include_path="/Users/grassjelly/Desktop/SC2107/Lab3ref_SimpleMotors" --include_path="/include" --advice:power=all --define=__MSP432P401R__ --define=TARGET_IS_MSP432P4XX --define=ccs -g --gcc --diag_warning=225 --diag_wrap=off --display_error_number --abi=eabi --preproc_with_compile --preproc_dependency="$(basename $(<F)).d_raw" $(GEN_OPTS__FLAG) "$<"
	@echo 'Finished building: "$<"'
	@echo ' '

LaunchPad.obj: /Users/grassjelly/Desktop/SC2107/inc/LaunchPad.c $(GEN_OPTS) | $(GEN_FILES) $(GEN_MISC_FILES)
	@echo 'MSP432 Compiler - building file: "$<"'
	"" -mv7M4 --code_state=16 --float_support=FPv4SPD16 -me --include_path="/Applications/ti/ccs2101/ccs/ccs_base/arm/include" --include_path="/Applications/ti/ccs2101/ccs/ccs_base/arm/include/CMSIS" --include_path="/Users/grassjelly/Desktop/SC2107/Lab3ref_SimpleMotors" --include_path="/include" --advice:power=all --define=__MSP432P401R__ --define=TARGET_IS_MSP432P4XX --define=ccs -g --gcc --diag_warning=225 --diag_wrap=off --display_error_number --abi=eabi --preproc_with_compile --preproc_dependency="$(basename $(<F)).d_raw" $(GEN_OPTS__FLAG) "$<"
	@echo 'Finished building: "$<"'
	@echo ' '

MotorSimple.obj: /Users/grassjelly/Desktop/SC2107/inc/MotorSimple.c $(GEN_OPTS) | $(GEN_FILES) $(GEN_MISC_FILES)
	@echo 'MSP432 Compiler - building file: "$<"'
	"" -mv7M4 --code_state=16 --float_support=FPv4SPD16 -me --include_path="/Applications/ti/ccs2101/ccs/ccs_base/arm/include" --include_path="/Applications/ti/ccs2101/ccs/ccs_base/arm/include/CMSIS" --include_path="/Users/grassjelly/Desktop/SC2107/Lab3ref_SimpleMotors" --include_path="/include" --advice:power=all --define=__MSP432P401R__ --define=TARGET_IS_MSP432P4XX --define=ccs -g --gcc --diag_warning=225 --diag_wrap=off --display_error_number --abi=eabi --preproc_with_compile --preproc_dependency="$(basename $(<F)).d_raw" $(GEN_OPTS__FLAG) "$<"
	@echo 'Finished building: "$<"'
	@echo ' '

%.obj: ../%.c $(GEN_OPTS) | $(GEN_FILES) $(GEN_MISC_FILES)
	@echo 'MSP432 Compiler - building file: "$<"'
	"" -mv7M4 --code_state=16 --float_support=FPv4SPD16 -me --include_path="/Applications/ti/ccs2101/ccs/ccs_base/arm/include" --include_path="/Applications/ti/ccs2101/ccs/ccs_base/arm/include/CMSIS" --include_path="/Users/grassjelly/Desktop/SC2107/Lab3ref_SimpleMotors" --include_path="/include" --advice:power=all --define=__MSP432P401R__ --define=TARGET_IS_MSP432P4XX --define=ccs -g --gcc --diag_warning=225 --diag_wrap=off --display_error_number --abi=eabi --preproc_with_compile --preproc_dependency="$(basename $(<F)).d_raw" $(GEN_OPTS__FLAG) "$<"
	@echo 'Finished building: "$<"'
	@echo ' '

SysTick.obj: /Users/grassjelly/Desktop/SC2107/inc/SysTick.c $(GEN_OPTS) | $(GEN_FILES) $(GEN_MISC_FILES)
	@echo 'MSP432 Compiler - building file: "$<"'
	"" -mv7M4 --code_state=16 --float_support=FPv4SPD16 -me --include_path="/Applications/ti/ccs2101/ccs/ccs_base/arm/include" --include_path="/Applications/ti/ccs2101/ccs/ccs_base/arm/include/CMSIS" --include_path="/Users/grassjelly/Desktop/SC2107/Lab3ref_SimpleMotors" --include_path="/include" --advice:power=all --define=__MSP432P401R__ --define=TARGET_IS_MSP432P4XX --define=ccs -g --gcc --diag_warning=225 --diag_wrap=off --display_error_number --abi=eabi --preproc_with_compile --preproc_dependency="$(basename $(<F)).d_raw" $(GEN_OPTS__FLAG) "$<"
	@echo 'Finished building: "$<"'
	@echo ' '


