selfplay.exe `
	--random 16 `
	--random_temperature 3 `
	--random2 1.2 `
	--min_move 24 `
	--mate_depth 27 `
	--mate_nodes 15000 `
	--max_move 512 `
	--threshold 1 `
	--threads 2 `
	--c_init 1.27 `
	--c_base 27126 `
	--c_fpu_reduction 31 `
	--c_init_root 1.12 `
	--c_base_root 33311 `
	--temperature 1.40 `
	--usi_engine ".\YaneuraOu-NNUE.exe" `
	--usi_engine_num 4 `
	--usi_threads 2 `
	--usi_options "USI_Ponder:false,Threads:1,NetworkDelay2:0,NodesLimit:1000000,USI_Hash:1024,PvInterval:99999" `
	"results\20241106_152638\result.onnx" "data\floodgate\floodgate23.hcp" "data\selfplay\output.hcpe3" 1000000 1000 0 128
