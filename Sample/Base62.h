//
//  Base62.h
//  Sample
//
//  Created by KentarOu on 2014/08/16.
//
//

#import <Foundation/Foundation.h>

//
// 62進数
// 1文字で、10進数の0～61までの数値を表現する。
// 0, 1, 2, ... 9, a, b, c, ... z, A, B, C, ... Z, 10, ...
//

// 注意1
// 16進数と比較して、アルファベットの大文字小文字を区別する点が異なります。

// 注意2
// BASE64と比較して、数字、小文字、大文字の並び順が逆です。



// 62進数対応 - 文字列クラス拡張
@interface NSString(Base62)
// 10進数 → 62進数文字列変換サポート
+(NSString*)base62StringWithInt:(int)value;
// 62進数文字列 → 10進数変換サポート
-(int)intValueAsBase62;
@end

// 62進数対応 - 数値クラス拡張
@interface NSNumber(Base62)
// 62進数文字列 → 10進数変換サポート
+(NSNumber*)numberWithBase62String:(NSString*)s;
// 10進数 → 62進数文字列変換サポート
-(NSString*)stringAsBase62;
@end