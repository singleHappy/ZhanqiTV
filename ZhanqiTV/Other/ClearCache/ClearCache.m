//
//  ClearCache.m
//  ZhanqiTV
//
//  Created by lechinepay on 16/7/4.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//

#import "ClearCache.h"

@implementation ClearCache
/**
 *  获取沙盒Caches的文件目录。
 */
+ (NSString *)CachesDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
}
// 按路径清除文件
+ (void)clearCachesWithFilePath:(NSString *)path
{
    dispatch_async(
                   
                   dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                   , ^{
                       NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                       NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
                       for (NSString *filePath in files) {//存在子目录
                           NSError *error;
                           NSRange range = [filePath rangeOfString:@"music"];//判断 不删除music文件夹及其下
                           if (!range.length ) {
                               NSString *path = [cachPath stringByAppendingPathComponent:filePath];
                               
                               if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                                   
                                   [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                               }
                               
                           }
                           //                           NSString *path = [cachPath stringByAppendingPathComponent:filePath];
                           //
                           //                           if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                           //
                           //                               [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                           //                           }
                           
                       }
                       //清除缓存之后调用的方法
                       [self performSelectorOnMainThread:@selector(clearCacheSuccess) withObject:nil waitUntilDone:YES];
                   });
    
}
+(void)clearCacheSuccess{
    //清除成功,可做响应成功之后的操作
}
/**
 *  返回path路径下文件的文件大小。
 */
+ (double)sizeWithFilePaht:(NSString *)path
{
    // 1.获得文件夹管理者
    NSFileManager *mgr = [NSFileManager defaultManager];
    // 2.检测路径的合理性,也就是监测一下缓存下面是否有缓存内容，如果为0，则返回不执行下面的操作
    BOOL dir = NO;
    BOOL exits = [mgr fileExistsAtPath:path isDirectory:&dir];
    // 2.检测路径的合理性,也就是监测一下缓存下面是否有缓存内容（缓存文件夹），如果为0，则返回不执行下面的操作
    //如果不存在缓存文件，则返回，就缓存为0，直接返回0就行，不用继续操作！
    if (!exits){
        return 0;
    }
    // 3.判断是否为文件夹
    if (dir) { // 文件夹, 遍历文件夹里面的所有文件
        // 这个方法能获得这个文件夹下面的所有子路径(直接\间接子路径)
        NSArray *subpaths = [mgr subpathsAtPath:path];
        int totalSize = 0;
        for (NSString *subpath in subpaths) {
            NSString *fullsubpath = [path stringByAppendingPathComponent:subpath];
            //注意判断fullsubpath（文件夹）是否存在，也是标示符
            BOOL dir = NO;
            [mgr fileExistsAtPath:fullsubpath isDirectory:&dir];
            if (!dir) { // 子路径是个文件
                NSDictionary *attrs = [mgr attributesOfItemAtPath:fullsubpath error:nil];
                //得到的结果是totalSize是以B为单位的，所以要除以1024 * 1024  转换到MB
                totalSize += [attrs[NSFileSize] intValue];
            }
        }
        return totalSize / (1024 * 1024.0);
    } else { // 文件
        NSDictionary *attrs = [mgr attributesOfItemAtPath:path error:nil];
        return [attrs[NSFileSize] intValue] / (1024 * 1024.0);
    }
}
/**
 *  - (void)cleanM:(UIButton *)sender{
 NSString *cache = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
 NSLog(@"%@",cache);
 double sizeM = [ProjectCleanCaches sizeWithFilePaht:cache];
 UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"缓存%.2fM",sizeM] message:@"是否清除" delegate:nil cancelButtonTitle:@"退出" otherButtonTitles:@"确定", nil];
 alertV.delegate = self;
 [alertV show];
 [alertV release];
 
 
 }
 
 - (void)pushDownLoading:(UIButton *)sender{
 DownLoadingViewController *downLoadingVC = [[DownLoadingViewController alloc] init];
 [self presentViewController:downLoadingVC animated:YES completion:^{
 
 }];
 [downLoadingVC release];
 }
 - (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
 
 if (buttonIndex == 1) {
 NSString *cache = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
 [ProjectCleanCaches clearCachesWithFilePath:cache];
 UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"清除成功" message:nil delegate:nil cancelButtonTitle:@"退出" otherButtonTitles:@"确定", nil];
 [alertV show];
 [alertV release];
 
 }
 }
 
 */

@end
