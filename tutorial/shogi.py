import cshogi

# 初期配置の局面を作成
board = cshogi.Board()
print(board)

# 合法手を列挙
for move in board.legal_moves:
    print(cshogi.move_to_usi(move))

# 7六歩を指す
move = board.push_usi('7g7f')
print(move)
print(board)
