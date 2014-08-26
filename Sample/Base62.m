//
//  Base62.m
//  Sample
//
//  Created by KentarOu on 2014/08/16.
//
//

#import "base62.h"

// 10進数を1文字に変換するためのテーブル
const char tableForDecToBase62Char[62] = {
    '0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
    'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j',
    'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't',
    'u', 'v', 'w', 'x', 'y', 'z', 'A', 'B', 'C', 'D',
    'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N',
    'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X',
    'Y', 'Z'
};

// 1文字を10進数の数値に変換するためのテーブル
const char tableForBase62CharToDec[256] = {
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 0, 0, 0, 0, 0,
    0,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,
    51,52,53,54,55,56,57,58,59,60,61,0, 0, 0, 0, 0,
    0,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,
    25,26,27,28,29,30,31,32,33,34,35,0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
};

// 62進数対応 - 文字列クラス拡張
@implementation NSString(Base62)

// 10進数 → 62進数文字列変換サポート
+(NSString*)base62StringWithInt:(int)value {
    // 後のループの都合上、ゼロだけ特別扱い
    if (0 == value) {
        return @"0";
    }
    
    // 一時変数準備
    char chars[16];              // 15文字分のバッファを確保
    chars[15] = 0;               // 文字列の終端をマーク
    char* pos = chars + 15;      // ポインタを文字列末尾にセットアップ
    bool minus = false;          // 負の値だったら、最後に、先頭に '-' をつける
    
    // 負の値チェック
    if (0 > value) {
        minus = true;            // 負の値フラグを立てる
        value *= -1;             // 符号を反転して正の数にする
    }
    
    // 0になるまでvalueを62で割り続ける
    while (0 != value) {
        // 次の文字の格納位置にポインタをずらす
        -- pos;
        
        // valueを62で割った余りをテーブルから参照して1文字取得 → ポインタ位置にセット
        *pos = tableForDecToBase62Char[value % 62];
        
        // 62で割ることによって、次の桁へ移動
        value /= 62;
    }
    
    // 負の値だったら、先頭にマイナス符号をつける
    if (minus) {
        -- pos;
        *pos = '-';        // 顔文字じゃないよ！
    }
    
    // ASCII文字列をNSStringにして返却
    return [NSString stringWithUTF8String:pos];
}

// 62進数文字列 → 10進数変換サポート
-(int)intValueAsBase62 {
    // 一時変数準備
    int result = 0;                      // 計算結果の値を保持する変数を0で初期化
    const char* p = [self UTF8String];   // 文字列へのポインタを取得
    bool minus = false;                  // 負の値だったら、最後に符号反転する
    
    // 1文字目で符号チェック
    if ('-' == *p) {
        minus = true;                    // 負の値フラグを立てる
        ++ p;                            // 1文字目が数字じゃないので、次のポインタを次の文字位置へ
    }
    
    // 文字列の末尾まで、1桁繰り上がるごとに62倍していく
    while (0 != *p) {
        // 現在の値を繰り上げ
        result *= 62;
        
        // 1文字を数値に変換して加算する
        result += tableForBase62CharToDec[*p];
        
        // 次の文字位置へ
        ++ p;
    }
    
    // 負の値だったら符号を反転
    if (minus) {
        result *= -1;
    }
    
    // 演算結果を返却
    return result;
}

@end

// 62進数対応 - 数値クラス拡張
@implementation NSNumber(Base62)

// 62進数文字列 → 10進数変換サポート
+(NSNumber*)numberWithBase62String:(NSString*)s {
    return [NSNumber numberWithInt:[s intValueAsBase62]];
}

// 62進数文字列 → 10進数変換サポート
-(NSString*)stringAsBase62 {
    return [NSString base62StringWithInt:[self intValue]];
}

@end
