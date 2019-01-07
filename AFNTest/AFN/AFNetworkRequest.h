//
//  AFNetworkRequest.h
//  BlogDemo
//
//  Created by Pan on 2017/8/3.
//  Copyright © 2017年 Pan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking/AFNetworking.h"
//请求方式：post、get、put、patch、delete
typedef NS_ENUM(NSUInteger, RequestMethod) {
    Request_POST = 0,
    Request_GET,
    Request_PUT,
    Request_PATCH,
    Request_DELETE
};
//错误状态码 iOS-sdk里面的 NSURLError.h 文件
typedef NS_ENUM (NSInteger, AFNetworkErrorType) {
    
    AFNetworkErrorType_TimedOut   = NSURLErrorTimedOut,//-1001 请求超时
    AFNetworkErrorType_UnURL      = NSURLErrorUnsupportedURL,//-1002 不支持的url
    AFNetworkErrorType_NoNetwork  = NSURLErrorNotConnectedToInternet,//-1009 断网
    AFNetworkErrorType_404Failed  = NSURLErrorBadServerResponse,//-1011 404错误
    AFNetworkErrorType_3840Failed = 3840,//请求或返回不是纯Json格式
};
@interface AFNetworkRequest : NSObject
/**
 *  AFNetworking请求方法
 *
 *  @param method     请求方式 Request_POST / Request_GET / Request_PUT / Request_PATCH / Request_DELETE
 *  @param parameters 请求参数 --支持NSArray, NSDictionary, NSSet这三种数据结构
 *  @param url        请求url字符串
 *  @param success    请求成功回调block
 */
+ (void)AFNetworkRequestWithRequestMethod:(RequestMethod)method parameters:(NSDictionary *)parameters url:(NSString *)url headerDic:(NSDictionary *)headerDic success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure;
/**
 *  AFNetworking上传图片方法
 *
 *  @param image      上传的图片
 *  @param url        请求url字符串
 *  @param success    请求成功回调block
 */
+(void)uploadImage:(UIImage *)image andUrl:(NSString *)url success:(void (^)(NSDictionary *dict))success failure:(void (^)(NSError *error))failure;

+(void)uploadImages:(NSArray<UIImage *> *)images paramsDic:(NSDictionary *)paramsDic url:(NSString *)url success:(void (^)(NSDictionary *dict))success failure:(void (^)(NSError *error))failure;




@end
