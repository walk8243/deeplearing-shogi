$date = (Get-Date -Format "yyyyMMdd_HHmmss")

New-Item -Name "results/$date" -ItemType "directory"

python -m dlshogi.train `
	--epoch 1 --batchsize 2048 `
	--checkpoint "results/$date/checkpoint-{epoch:03}.pth" `
	--model "results/$date/result.model" `
	--log "logs/train-$date.log" `
	--lr 0.02 --use_amp --use_evalfix `
	data/floodgate/train.hcpe data/floodgate/test.hcpe

python -m dlshogi.convert_model_to_onnx `
	"results/$date/result.model" "results/$date/result.onnx"

python ./utils/plot_log_policy_value.py `
	"logs/train-$date.log" "results/$date/plot.png"
