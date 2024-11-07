Param(
	[string]$Dataset,
	[string]$Roots
)

$Dir = ""
if ($Roots) {
	$Target = ((Get-Item -Path "$Roots" -ErrorAction Stop).FullName | Resolve-Path -Relative).Substring(2)
	"$Target to hcpe"
	$Dir = (Resolve-Path "$Target\..\" -Relative).SubString(2)
	python -m dlshogi.utils.hcpe3_to_hcpe `
		"$Target" "$Dir\train.hcpe"
}
elseif ($Dataset) {
	Get-Item -Path "$Dataset" -ErrorAction Stop
	$Dir = (Resolve-Path $Dataset -Relative).SubString(2)
	"$Dir csa to hcpe"
	python -m dlshogi.utils.csa_to_hcpe `
		"$Dir" "$Dir\train.hcpe" `
		--eval 5000 --filter_moves 50 `
		--filter_rating 3500
}
else {
	throw "Specify Dataset or Roots"
}

$Output = python -m dlshogi.utils.uniq_hcpe `
	--average `
	"$Dir\train.hcpe" "$Dir\train_average.hcpe"
$Num = "$Output".Split("") | Select-Object -Last 1
"Unique Cases: $Num"
$Digits = ([string]$Num).Length
$SampleNum = 0
if ($Digits -gt 5) {
	$SampleNum = [Math]::Pow(2, $Digits - 2) * 10000
}
elseif ($Num -lt 10) {
	$SampleNum = $Num
}
else {
	$SampleNum = $Num -shr 2
}

python -m dlshogi.utils.sample_hcpe `
	"$Dir\train_average.hcpe" "$Dir\test.hcpe" $SampleNum
