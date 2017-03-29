//
//  AnswerSheeCell.m
//  DoctorBuestionBank
//
//  Created by 杨强 on 16/10/25.
//  Copyright © 2016年 杨强. All rights reserved.
//

#import "AnswerSheeCell.h"





@interface AnswerSheeCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLable;

@property(nonatomic , strong) NSString * outColor;
@property(nonatomic , strong) NSString * inColor;

@end

@implementation AnswerSheeCell





-(void) drawRect:(CGRect)rect
{
    
    
    
    
    CGFloat x = 5;
    CGFloat w =rect.size.width;
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGRect frame = CGRectMake(x, x, w - 2*x, w - 2*x);


    CGContextAddEllipseInRect(context, frame);
    
    UIColor * color = [UIColor colorFromHexRGB:self.outColor];
    [color set];
    CGContextFillPath(context);
    CGContextRestoreGState(context);
    
    
    x = x+2;
    
    frame = CGRectMake(x, x, w - 2*x, w - 2*x);
    
    CGContextAddEllipseInRect(context, frame);
    
    color = [UIColor colorFromHexRGB:self.inColor];
    [color set];
    CGContextFillPath(context);
    
    


}


-(void) setItem:(NSInteger)item
{
    self.titleLable.text = [NSString stringWithFormat:@"%ld" , item];
    

}




-(void)setColorType:(CollectionViewCellColorType)colorType
{

    if (colorType == UCollectionViewCellColorNone) {
        _outColor =@"eaeaea";
        _inColor =@"fafafa";
        self.titleLable.textColor = [UIColor colorFromHexRGB:@"999999"];
        
    }else if(colorType == UCollectionViewCellColorSelect){
    
        _outColor = @"6f80c8";
        _inColor = @"ecf1f7";
        self.titleLable.textColor = [UIColor colorFromHexRGB:@"999999"];

        
    }else if(colorType == UCollectionViewCellColorRight)
    {
        _outColor = @"7ed184";
        _inColor = @"d8f6da";
        self.titleLable.textColor = [UIColor colorFromHexRGB:@"73cb75"];

        
    
    }else if(colorType == UCollectionViewCellColorWrong){
    
        _outColor = @"fe9b9e";
        _inColor = @"ffd8d9";
        self.titleLable.textColor = [UIColor colorFromHexRGB:@"ff686c"];

        
    
    }

 
    
    [self setNeedsDisplay];


}



-(NSString *) outColor
{
    
    if ((_outColor == nil) || (_outColor.length == 0)) {
        
        _outColor =@"6f80c8";
        
    }
    
    return _outColor;
    
    
}

-(NSString *) inColor
{
    
    if (!_inColor || (_inColor.length == 0)) {
        _inColor =@"ecf1f7";
        
    }
    
    return _inColor ;
    
    
}



@end
