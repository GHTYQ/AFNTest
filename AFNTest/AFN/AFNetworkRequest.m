//
//  AFNetworkRequest.m
//  BlogDemo
//
//  Created by Pan on 2017/8/3.
//  Copyright © 2017年 Pan. All rights reserved.
//

#import "AFNetworkRequest.h"
#import "AFNetworking/AFNetworking.h"
@implementation AFNetworkRequest
/**
 *  AFNetworking请求方法
 *
 *  @param method     请求方式 Request_POST / Request_GET / Request_PUT / Request_PATCH / Request_DELETE
 *  @param parameters 请求参数
 *  @param url        请求url字符串
 *  @param success    请求成功回调block
 */
+ (void)AFNetworkRequestWithRequestMethod:(RequestMethod)method parameters:(NSDictionary *)parameters url:(NSString *)url headerDic:(NSDictionary *)headerDic success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/javascript",@"text/plain", nil];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 20.0f;//超时时间
    if (headerDic) {
        [headerDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            NSLog(@"%@,%@",key,obj);
            [manager.requestSerializer setValue:obj forHTTPHeaderField:key];
        }];
    }
    
    switch (method) {
        case Request_POST:{
            [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (success) {
                    success(responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if(failure){
                    failure(error);
                }
            }];
        }   break;
        case Request_GET:{
            [manager GET:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (success) {
                    success(responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             
                if(failure){
                    failure(error);
                }
            }];
        }   break;
        case Request_PUT:{
            [manager PUT:url parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (success) {
                    success(responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if(failure){
                    failure(error);
                }
            }];
        }   break;
        case Request_PATCH:{
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            [manager PATCH:url parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (success) {
                    success(responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if(failure){
                    failure(error);
                }
            }];
        }   break;
        case Request_DELETE:{
            [manager DELETE:url parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (success) {
                    success(responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if(failure){
                    failure(error);
                }
            }];
        }   break;
        default:
            break;
    }
}


+(void)uploadImage:(UIImage *)image andUrl:(NSString *)url success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure{
    NSLog(@"开始上传image");
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //接收类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                             @"text/html",
                                                             @"image/jpeg",
                                                             @"image/png",
                                                             @"application/octet-stream",
                                                             @"text/json",
                                                             nil];
    NSData *imageData =UIImageJPEGRepresentation(image,0.5);
    //调用获取图片扩展名
    NSString *string = [AFNetworkRequest contentTypeForImageData:imageData];
    if ([string isEqualToString:@"png"] || [string isEqualToString:@"jpeg"]) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        formatter.dateFormat =@"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
        NSURLSessionDataTask *task = [manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
            //上传的参数(上传图片，以文件流的格式)
            [formData appendPartWithFileData:imageData
                                        name:@"file"
                                    fileName:fileName
                                    mimeType:@"image/jpeg"];
        } progress:^(NSProgress *_Nonnull uploadProgress) {
            //打印下上传进度
        } success:^(NSURLSessionDataTask *_Nonnull task,id _Nullable responseObject) {
            NSDictionary * dict  = responseObject;
            if (success) {
                success(dict);
            }
        } failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            if (failure) {
                failure(error);
            }
        }];
        [task resume];
    }else{
     
    }
 
}
+ (void)uploadImages:(NSArray<UIImage *> *)images paramsDic:(NSDictionary *)paramsDic url:(NSString *)url success:(void (^)(NSDictionary *dict))success failure:(void (^)(NSError *error))failure {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 20;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
    [manager POST:url parameters:paramsDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        // formData: 专门用于拼接需要上传的数据,在此位置生成一个要上传的数据体
        // 这里的_photoArr是你存放图片的数组
        for (int i = 0; i < images.count; i++) {
            UIImage *image = images[i];
            NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
            //调用获取图片扩展名
            NSString *string = [AFNetworkRequest contentTypeForImageData:imageData];
            if ([string isEqualToString:@"png"] || [string isEqualToString:@"jpeg"]) {
                // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
                // 要解决此问题，
                // 可以在上传时使用当前的系统事件作为文件名
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                // 设置时间格式
                [formatter setDateFormat:@"yyyyMMddHHmmss"];
                NSString *dateString = [formatter stringFromDate:[NSDate date]];
                NSString *fileName = [NSString  stringWithFormat:@"%@.jpg", dateString];
                /*
                 *该方法的参数
                 1. appendPartWithFileData：要上传的照片[二进制流]
                 2. name：对应网站上[upload.php中]处理文件的字段（比如myfile）
                 3. fileName：要保存在服务器上的文件名
                 4. mimeType：上传的文件的类型
                 */
                [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/jpeg"]; //
            }else{
            
            }
        }
        
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        //上传进度
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSLog(@"progress is %@",uploadProgress);
        });
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSData class]]) {
            responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        }
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failure(error);
        
    }];
}
//通过图片Data数据第一个字节 来获取图片扩展名
+(NSString *)contentTypeForImageData:(NSData *)data{
    uint8_t c;
    [data getBytes:&c length:1];
    switch (c) {
        case 0xFF:
            return @"jpeg";
        case 0x89:
            return @"png";
        case 0x47:
            return @"gif";
        case 0x49:
        case 0x4D:
            return @"tiff";
        case 0x52:
            if ([data length] < 12) {
                return nil;
            }
            NSString *testString = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(0, 12)] encoding:NSASCIIStringEncoding];
            if ([testString hasPrefix:@"RIFF"] && [testString hasSuffix:@"WEBP"]) {
                return @"webp";
            }
            return nil;
    }
    return nil;
}




@end
