//
//  XVimTester+Search.m
//  XVim
//
//  Created by Suzuki Shuichiro on 8/18/13.
//
//

#import "XVimTester.h"

@implementation XVimTester (Search)
#import "XVimTester.h"

- (NSArray*)search_testcases{
    static NSString* text1 = @"aaa\n"   // 0  (index of each WORD)
                             @"bbb\n"   // 4
                             @"ccc";    // 8
    
    static NSString* text2 = @"a;a bbb ccc\n"  // 0  4  8
                             @"ddd e-e fff\n"  // 12 16 20
                             @"ggg bbb i_i\n"  // 24 28 32
                             @"    jjj bbb";   // 36 40 44
    
    static NSString* text3 = @"a;a bbb ccc\n"  // 0  4  8
                             @"ddd e-e fff\n"  // 12 16 20
                             @"ggggbbbii_i\n"  // 24 28 32
                             @"    jjj bbb";   // 36 40 44
    
    static NSString* text4 = @"a;a bbb ccc\n"  // 0  4  8
                             @"ddd e-e fff\n"  // 12 16 20
                             @"ggg BBB i_i\n"  // 24 28 32
                             @"    jjj BbB";   // 36 40 44
    
    static NSString* text5 = @"a;a bbb ccc\n"  // 0  4  8
                             @"ddd e-e fff\n"  // 12 16 20
                             @"ggg BBB i_i\n"  // 24 28 32
                             @"    jjj bbb";   // 36 40 44
    
    static NSString* text6 = @"aaa bbb ccc\n"
                             @"bbb ccc ccc\n"
                             @"bbb ccc ddd\n";
    
    static NSString* text7 = @"aaa bbb ccc\n"
                             @"bbb ccc ccc\n\n";
    
    static NSString* replace1_result =   @"eeeee bbb ccc\n"
                                         @"bbb ccc ccc\n"
                                         @"bbb ccc ddd\n";
    
    static NSString* replace2_result =   @"aaa eeeee ccc\n"
                                         @"bbb ccc ccc\n"
                                         @"bbb ccc ddd\n";
    
    static NSString* replace3_result =   @"aaa eeeee ccc\n"
                                         @"eeeee ccc ccc\n"
                                         @"bbb ccc ddd\n";
    
    static NSString* replace4_result =   @"eeeeeaaa bbb ccc\n"
                                         @"bbb ccc ccc\n"
                                         @"bbb ccc ddd\n";
    
    static NSString* replace5_result =   @"eeeeeaaa bbb ccc\n"
                                         @"eeeeebbb ccc ccc\n"
                                         @"bbb ccc ddd\n";
    
    static NSString* replace6_result =   @"aaa bbb cccfffff\n"
                                         @"bbb ccc ccc\n"
                                         @"bbb ccc ddd\n";
    
    static NSString* replace7_result =   @"aaa bbb cccfffff\n"
                                         @"bbb ccc cccfffff\n"
                                         @"bbb ccc ddd\n";
    
    static NSString* replace8_result =   @"aaa bbb cccfffff\n"
                                         @"bbb ccc cccfffff\n\n";
    
    return [NSArray arrayWithObjects:
            //
            // replace(:s)
            //
            XVimMakeTestCase(text6, 0,  0, @":%s/aaa/eeeee<CR>", replace1_result, 5, 0),
            // only first one
            XVimMakeTestCase(text6, 0,  0, @"Vj:s/bbb/eeeee<CR>", replace2_result, 9, 0),
            // two
            XVimMakeTestCase(text6, 0,  0, @"Vj:s/bbb/eeeee/g<CR>", replace3_result, 9, 0),
            // ^, only first one
            XVimMakeTestCase(text6, 0,  0, @"Vj:s/^/eeeee<CR>", replace4_result, 5, 0),
            // ^, two
            XVimMakeTestCase(text6, 0,  0, @"Vj:s/^/eeeee/g<CR>", replace5_result, 22, 0),
            // $, only first one
            XVimMakeTestCase(text6, 0,  0, @"Vj:s/$/fffff<CR>", replace6_result, 15, 0),
            // $, two
            XVimMakeTestCase(text6, 0,  0, @"Vj:s/$/fffff/g<CR>", replace7_result, 15, 0),
            // $, two
            XVimMakeTestCase(text7, 0,  0, @"Vj:s/$/fffff/g<CR>", replace8_result, 15, 0),
            
            // Search (/,?)
            XVimMakeTestCase(text1, 0,  0, @"/bbb<CR>", text1, 4, 0),
            XVimMakeTestCase(text1, 8,  0, @"?bbb<CR>", text1, 4, 0),
            
            // Repeating search
            XVimMakeTestCase(text2, 0,  0, @"/bbb<CR>n" , text2, 28, 0),
            XVimMakeTestCase(text2, 0,  0, @"/bbb<CR>nN", text2,  4, 0),
            XVimMakeTestCase(text2,40,  0, @"?bbb<CR>n" , text2,  4, 0),
            XVimMakeTestCase(text2,40,  0, @"?bbb<CR>nN", text2, 28, 0),
            
            // Search words (*,#,g*,g#)
            XVimMakeTestCase(text2, 5,  0, @"*" , text2, 28, 0),
            XVimMakeTestCase(text2, 5,  0, @"2*", text2, 44, 0),
            XVimMakeTestCase(text2,45,  0, @"#" , text2, 28, 0),
            XVimMakeTestCase(text2,45,  0, @"2#", text2,  4, 0),
            
            // * or # should only word boundary
            XVimMakeTestCase(text3, 5,  0, @"*" , text3, 44, 0),
            XVimMakeTestCase(text3,45,  0, @"#" , text3,  4, 0),
            // g* or g# should match without word boundary
            XVimMakeTestCase(text2, 5,  0, @"*" , text2, 28, 0),
            XVimMakeTestCase(text2,45,  0, @"#" , text2, 28, 0),
            
            // # must not match the searched word itself
            XVimMakeTestCase(text2, 29,  0, @"#" , text2, 4, 0),
            
            // Search with * or # must be saved in search history
            XVimMakeTestCase(text2, 5,  0, @"*/<UP><CR>" , text2, 44, 0),
            XVimMakeTestCase(text2,45,  0, @"#?<UP><CR>" , text2, 4, 0),
            
            // Operations with search
            // Currently operations with search is supported but not exactly compatible to Vim's behavior.
            // This is related to the fact that XVim moves cursor before doing */# search not to match the searched string itsself.
            // XVimMakeTestCase(text2, 5,  0, @"2d*" , operation_result1, 5, 0),
            // XVimMakeTestCase(text2,45,  0, @"2d#" , operation_result2, 4, 0),
            
            // Options for search
            // wrapscan
            XVimMakeTestCase(text2, 45,  0, @":set wrapscan<CR>*", text2, 4, 0),
            XVimMakeTestCase(text2, 5,  0, @":set wrapscan<CR>#", text2, 44, 0),
            // if no match string is found the cursor move the the head of the word
            XVimMakeTestCase(text2, 45,  0, @":set nowrapscan<CR>*" , text2, 44, 0),
            XVimMakeTestCase(text2, 5,  0, @":set nowrapscan<CR>#" , text2, 4, 0),
            
            // ignorecase
            XVimMakeTestCase(text4, 5,  0, @":set ignorecase<CR>*", text4, 28, 0),
            XVimMakeTestCase(text4, 5,  0, @":set noignorecase<CR>*", text4, 4, 0),
            
            // vimregex
            // \c, \C specify case insensitive or sensitive.
            // These specifier overrides 'ignorecase' or 'smartcase' option
            XVimMakeTestCase(text5, 5, 0, @":set vimregex<CR>:set noignorecase<CR>/bbb\\c<CR>" , text5, 28, 0), // should ignore case
            XVimMakeTestCase(text5, 5, 0, @":set vimregex<CR>:set ignorecase<CR>/bbb\\C<CR>" , text5,  44, 0), // should not ignore case
            // \<,\> must match word boundary (converted to \b internally)
            XVimMakeTestCase(text3, 5,  0, @":set vimregex<CR>/\\<bbb\\><CR>" , text3, 44, 0),
            XVimMakeTestCase(text3,44,  0, @":set vimregex<CR>?\\<bbb\\><CR>" , text3,  4, 0),
            
            // * or # should only word boundary - should work also when vimregex is on
            XVimMakeTestCase(text3, 5,  0, @":set vimregex<CR>*" , text3, 44, 0),
            XVimMakeTestCase(text3,45,  0, @":set vimregex<CR>#" , text3,  4, 0),
            
            nil];
}
@end
