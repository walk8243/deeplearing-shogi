Param(
	[int32]$Epoch = 1,
	[string]$Prevent,
	[switch]$UsePreTrain,
	[string]$Data = "data\floodgate"
)

$date = (Get-Date -Format "yyyyMMdd_HHmmss")

$resume = ""
if ($UsePreTrain) {
	$Prevent = "results\" `
		+ (Get-Item -Path "results/*" -Exclude ".*" | Sort-Object -Property CreationTime | Select-Object -Last 1).Name
}
if ($Prevent) {
	Get-Item -Path "$Prevent" -ErrorAction Stop | Out-Null
	$checkpoint = (Get-Item -Path "$Prevent/*" -Include "checkpoint-*.pth").Name | Sort-Object | Select-Object -Last 1
	$resume = (Resolve-Path "$Prevent\" -Relative).SubString(2) + "\" + $checkpoint
}

New-Item -Name "results/$date" -ItemType "directory" | Out-Null

$TrainData = (Join-Path -Path $Data -ChildPath "train.hcpe").Substring(2)
$TestData = (Join-Path -Path $Data -ChildPath "test.hcpe").Substring(2)

python -m dlshogi.train `
	--epoch $Epoch --batchsize 2048 `
	--checkpoint "results/$date/checkpoint-{epoch:03}.pth" `
	--resume "$resume" `
	--model "results/$date/result.model" `
	--log "logs/train-$date.log" `
	--lr 0.02 --use_amp --use_evalfix `
	$TrainData $TestData

python -m dlshogi.convert_model_to_onnx `
	"results/$date/result.model" "results/$date/result.onnx"

python ./utils/plot_log_policy_value.py `
	"logs/train-$date.log" --save "results/$date/train.png"
python ./utils/plot_log_policy_value.py `
	"logs/train-$date.log" --save "results/$date/test.png" --testloss
