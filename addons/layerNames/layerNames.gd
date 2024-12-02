extends Node
enum RENDER_2D { 
NONE = 0,
LAYER_1 = 1,
LAYER_2 = 2,
LAYER_3 = 4,
LAYER_4 = 8,
LAYER_5 = 16,
LAYER_6 = 32,
LAYER_7 = 64,
LAYER_8 = 128,
LAYER_9 = 256,
LAYER_10 = 512,
LAYER_11 = 1024,
LAYER_12 = 2048,
LAYER_13 = 4096,
LAYER_14 = 8192,
LAYER_15 = 16384,
LAYER_16 = 32768,
LAYER_17 = 65536,
LAYER_18 = 131072,
LAYER_19 = 262144,
LAYER_20 = 524288,
}

enum PHYSICS_2D { 
NONE = 0,
PLAYER_COLLSION = 1,
SOLID_FOREGROUND = 2,
PLAYER_HURTBOX = 4,
DEADZONE = 8,
SEMI_SOLID_FOREGROUND = 16,
COLLIDE_CHECK = 32,
LAYER_7 = 64,
LAYER_8 = 128,
LAYER_9 = 256,
LAYER_10 = 512,
LAYER_11 = 1024,
LAYER_12 = 2048,
LAYER_13 = 4096,
LAYER_14 = 8192,
LAYER_15 = 16384,
LAYER_16 = 32768,
LAYER_17 = 65536,
LAYER_18 = 131072,
LAYER_19 = 262144,
LAYER_20 = 524288,
LAYER_21 = 1048576,
LAYER_22 = 2097152,
LAYER_23 = 4194304,
LAYER_24 = 8388608,
LAYER_25 = 16777216,
LAYER_26 = 33554432,
LAYER_27 = 67108864,
LAYER_28 = 134217728,
LAYER_29 = 268435456,
LAYER_30 = 536870912,
LAYER_31 = 1073741824,
LAYER_32 = 2147483648,
}

enum NAVIGATION_2D { 
NONE = 0,
LAYER_1 = 1,
LAYER_2 = 2,
LAYER_3 = 4,
LAYER_4 = 8,
LAYER_5 = 16,
LAYER_6 = 32,
LAYER_7 = 64,
LAYER_8 = 128,
LAYER_9 = 256,
LAYER_10 = 512,
LAYER_11 = 1024,
LAYER_12 = 2048,
LAYER_13 = 4096,
LAYER_14 = 8192,
LAYER_15 = 16384,
LAYER_16 = 32768,
LAYER_17 = 65536,
LAYER_18 = 131072,
LAYER_19 = 262144,
LAYER_20 = 524288,
LAYER_21 = 1048576,
LAYER_22 = 2097152,
LAYER_23 = 4194304,
LAYER_24 = 8388608,
LAYER_25 = 16777216,
LAYER_26 = 33554432,
LAYER_27 = 67108864,
LAYER_28 = 134217728,
LAYER_29 = 268435456,
LAYER_30 = 536870912,
LAYER_31 = 1073741824,
LAYER_32 = 2147483648,
}

enum RENDER_3D { 
NONE = 0,
LAYER_1 = 1,
LAYER_2 = 2,
LAYER_3 = 4,
LAYER_4 = 8,
LAYER_5 = 16,
LAYER_6 = 32,
LAYER_7 = 64,
LAYER_8 = 128,
LAYER_9 = 256,
LAYER_10 = 512,
LAYER_11 = 1024,
LAYER_12 = 2048,
LAYER_13 = 4096,
LAYER_14 = 8192,
LAYER_15 = 16384,
LAYER_16 = 32768,
LAYER_17 = 65536,
LAYER_18 = 131072,
LAYER_19 = 262144,
LAYER_20 = 524288,
}

enum PHYSICS_3D { 
NONE = 0,
LAYER_1 = 1,
LAYER_2 = 2,
LAYER_3 = 4,
LAYER_4 = 8,
LAYER_5 = 16,
LAYER_6 = 32,
LAYER_7 = 64,
LAYER_8 = 128,
LAYER_9 = 256,
LAYER_10 = 512,
LAYER_11 = 1024,
LAYER_12 = 2048,
LAYER_13 = 4096,
LAYER_14 = 8192,
LAYER_15 = 16384,
LAYER_16 = 32768,
LAYER_17 = 65536,
LAYER_18 = 131072,
LAYER_19 = 262144,
LAYER_20 = 524288,
LAYER_21 = 1048576,
LAYER_22 = 2097152,
LAYER_23 = 4194304,
LAYER_24 = 8388608,
LAYER_25 = 16777216,
LAYER_26 = 33554432,
LAYER_27 = 67108864,
LAYER_28 = 134217728,
LAYER_29 = 268435456,
LAYER_30 = 536870912,
LAYER_31 = 1073741824,
LAYER_32 = 2147483648,
}

enum NAVIGATION_3D { 
NONE = 0,
LAYER_1 = 1,
LAYER_2 = 2,
LAYER_3 = 4,
LAYER_4 = 8,
LAYER_5 = 16,
LAYER_6 = 32,
LAYER_7 = 64,
LAYER_8 = 128,
LAYER_9 = 256,
LAYER_10 = 512,
LAYER_11 = 1024,
LAYER_12 = 2048,
LAYER_13 = 4096,
LAYER_14 = 8192,
LAYER_15 = 16384,
LAYER_16 = 32768,
LAYER_17 = 65536,
LAYER_18 = 131072,
LAYER_19 = 262144,
LAYER_20 = 524288,
LAYER_21 = 1048576,
LAYER_22 = 2097152,
LAYER_23 = 4194304,
LAYER_24 = 8388608,
LAYER_25 = 16777216,
LAYER_26 = 33554432,
LAYER_27 = 67108864,
LAYER_28 = 134217728,
LAYER_29 = 268435456,
LAYER_30 = 536870912,
LAYER_31 = 1073741824,
LAYER_32 = 2147483648,
}

enum AVOIDANCE { 
NONE = 0,
LAYER_1 = 1,
LAYER_2 = 2,
LAYER_3 = 4,
LAYER_4 = 8,
LAYER_5 = 16,
LAYER_6 = 32,
LAYER_7 = 64,
LAYER_8 = 128,
LAYER_9 = 256,
LAYER_10 = 512,
LAYER_11 = 1024,
LAYER_12 = 2048,
LAYER_13 = 4096,
LAYER_14 = 8192,
LAYER_15 = 16384,
LAYER_16 = 32768,
LAYER_17 = 65536,
LAYER_18 = 131072,
LAYER_19 = 262144,
LAYER_20 = 524288,
LAYER_21 = 1048576,
LAYER_22 = 2097152,
LAYER_23 = 4194304,
LAYER_24 = 8388608,
LAYER_25 = 16777216,
LAYER_26 = 33554432,
LAYER_27 = 67108864,
LAYER_28 = 134217728,
LAYER_29 = 268435456,
LAYER_30 = 536870912,
LAYER_31 = 1073741824,
LAYER_32 = 2147483648,
}

