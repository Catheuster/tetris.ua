# Experimental!
I ~ "git: github.com/Marcos-cat/iris"
I~Open 700_900 "Tetra Block"

~Piece {Map Coords}
~State {ActivePiece Board Score FrameCounter}
CreatePiece ← (
  0_3
  ×+₁⟜⨬(
    ▽4¤0_1_0_0          # I Piece
  | [0_1_0 0_1_0 1_1_0] # J Piece
  | [0_1_0 0_1_0 0_1_1] # L Piece
  | [0_1_0 1_1_1 0_0_0] # T Piece
  | [1_1 1_1]           # O Piece
  | [0_1_1 1_1_0 0_0_0] # S Piece
  | [1_1_0 0_1_1 0_0_0] # Z Piece
  )⚂₇
  Piece~New
)
Init ← State~New CreatePiece ▽20¤▽10 0 0 0

┌─╴Colision
  WithPieces ↚ /↥∊:⍉+⊃(Piece~Coords|⍉⊚±Piece~Map|⊚±⋅State~Board)
  WithWalls  ↚ /↥⊂∩♭⊃(<0_0|>19_9)+⊃(Piece~Coords|⍉⊚±Piece~Map)
  Colision   ← ↥⊃WithWalls WithPieces⊸State~ActivePiece
  Try! ← (
    ⊸(Colision ⍜State~ActivePiece ^0)
    ⨬(⍜State~ActivePiece ^0|∘)
  )
└─╴

┌─╴Draw
  CombineMap ← ↥↻¯⊃(⊃(Piece~Coords|⬚0↙20_10 Piece~Map) State~ActivePiece|State~Board)
  DrawMap    ← ≡(I~Draw~Square) ¤Blue 26 ⍉⇌+202×30⍉⊚±CombineMap
└─╴

┌─╴Movement
  Rotate⌟  ← Colision~Try!⍜Piece~Map (⍉⇌)
  Rotate⌞  ← Colision~Try!⍜Piece~Map (⇌⍉)
  Right    ← Colision~Try!⍜Piece~Coords (+ 0_1)
  Left     ← Colision~Try!⍜Piece~Coords (- 0_1)
  SoftDrop ← Colision~Try!⍜Piece~Coords (+ 1_0)
  Fix ↚ (
    ⍜State~Board(⋅∘)⟜Draw~CombineMap # Fix Piece
    ⍜State~ActivePiece(CreatePiece◌) # Spawn New Piece
    ⍜State~Board(⍜⇌⬚0↙₂₀▽¬±⊸≡/↧)     # Remove Completed Lines
  )
  GDrop ↚ (
    ⊸(Colision~Colision⍜State~ActivePiece⍜Piece~Coords (+1_0)) # Test Colision
    ⨬(⍜State~ActivePiece⍜Piece~Coords (+1_0)|Fix)
  )
  Gravity ← (
    ⊸(≥ 10 State~FrameCounter)       # Test Frame
    ⨬(∘|GDrop ⍜State~FrameCounter×₀) # Drop
  )
└─╴

Init
# Start the game loop
°I~Screen~FPS 20
I~Loop!(
  # Draw the background blue
  I~Draw~Background Black
  I~Draw~Rect White 306_606 197_197
  I~Draw~Rect Black 300_600 200_200
  ⟜Draw~DrawMap
  ⍜State~FrameCounter (+1)
  Movement~Gravity
  #   I~Draw~Text Red 10 50_50 ⊸(°⋕State~FrameCounter)
  I~Key~Down‼@a Movement~Left
  I~Key~Down‼@d Movement~Right
  I~Key~Pressed‼@. Movement~Rotate⌟
  I~Key~Pressed‼@, Movement~Rotate⌞
  I~Key~Down‼@s Movement~SoftDrop
)
