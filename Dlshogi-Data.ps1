Param(
	[string]$Dataset,
	[string]$Roots
)

$Dir = ""
if ($Roots) {
	$Target = (Get-Item -Path "data/$Roots" -ErrorAction Stop).DirectoryName
	"$Roots to hcpe"
	Push-Location "data"
	$Dir = (Resolve-Path $Target -Relative).SubString(2)
	Pop-Location
	python -m dlshogi.utils.hcpe3_to_hcpe `
		"data/$Roots" "data/$Dir/train.hcpe"
}
elseif ($Dataset) {
	Get-Item -Path "data/$Dataset" -ErrorAction Stop
	"$Dataset csa to hcpe"
	$Dir = $Dataset
	python -m dlshogi.utils.csa_to_hcpe `
		"data/$Dataset" "data/$Dir/train.hcpe" `
		--eval 5000 --filter_moves 50 `
		--filter_rating 3500
}
else {
	throw "Specify Dataset or Roots"
}

python -m dlshogi.utils.uniq_hcpe `
	--average `
	"data/$Dir/train.hcpe" "data/$Dir/train_average.hcpe"

python -m dlshogi.utils.sample_hcpe `
	"data/$Dir/train_average.hcpe" "data/$Dir/test.hcpe" `
	640000
