//
//  BusDetailViewController.m
//  MapProject2
//
//  Created by Khanhcoc on 18/04/2013.
//  Copyright (c) 2013 Khue TD. All rights reserved.
//

#import "BusDetailViewController.h"
#import "MapBusViewController.h"

@interface BusDetailViewController ()

@end

@implementation BusDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //self.navigationItem.title   = self.busO.sName;
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    title.font = [UIFont boldSystemFontOfSize:14.2];
    title.backgroundColor = [UIColor clearColor];
    title.textColor = [UIColor whiteColor];
    title.text = self.busO.sName;
    self.navigationItem.titleView   = title ;
    
    // Khoi tao cac doi tuong co dinh
    // NHAN
    lsBusNumber = [[UILabel alloc] initWithFrame:CGRectMake(35, 10, 200, 20)];
    [lsBusNumber setText:@"Số hiệu tuyến:  "];
    lsBusNumber.font = [UIFont boldSystemFontOfSize:13];
    
    lsTimeBegin = [[UILabel alloc] initWithFrame:CGRectMake(35, 40, 200, 20)];
    [lsTimeBegin setText:@"Khởi hành:  "];
    lsTimeBegin.font = [UIFont boldSystemFontOfSize:13];
    
    lsTimeFinish = [[UILabel alloc] initWithFrame:CGRectMake(35, 70, 200, 20)];
    [lsTimeFinish setText:@"Kết thúc:  "];
    lsTimeFinish.font = [UIFont boldSystemFontOfSize:13];
    
    lsBusType = [[UILabel alloc] initWithFrame:CGRectMake(35, 100, 200, 20)];
    [lsBusType setText:@"Loại xe:  "];
    lsBusType.font = [UIFont boldSystemFontOfSize:13];
    
    lsBusPrice = [[UILabel alloc] initWithFrame:CGRectMake(35, 130, 200, 20)];
    [lsBusPrice setText:@"Giá vé:  "];
    lsBusPrice.font = [UIFont boldSystemFontOfSize:13];
    
    lsBusGoto = [[UILabel alloc] initWithFrame:CGRectMake(35, 160, 200, 20)];
    [lsBusGoto setText:@"Lượt đi:  "];
    lsBusGoto.font = [UIFont boldSystemFontOfSize:13];
    
    
    // ANH
    iBusNumber = [UIImage imageNamed:@"Flag.png"];
    ivBusNumber = [[UIImageView alloc]initWithImage:iBusNumber ];
    ivBusNumber.frame = CGRectMake(5, 7, 24, 24);
    
    iTimeBegin = [UIImage imageNamed:@"clock.png"];
    ivTimeBegin = [[UIImageView alloc]initWithImage:iTimeBegin ];
    ivTimeBegin.frame = CGRectMake(5, 37, 24, 24);
    
    iTimeFinish = [UIImage imageNamed:@"clock.png"];
    ivTimeFinish = [[UIImageView alloc]initWithImage:iTimeFinish ];
    ivTimeFinish.frame = CGRectMake(5, 67, 24, 24);
    
    iBustype = [UIImage imageNamed:@"4.png"];
    ivBustype = [[UIImageView alloc]initWithImage:iBustype ];
    ivBustype.frame = CGRectMake(5, 97, 24, 24);
    
    iBusPrice = [UIImage imageNamed:@"price.png"];
    ivBusPrice = [[UIImageView alloc]initWithImage:iBusPrice ];
    ivBusPrice.frame = CGRectMake(5, 127, 24, 24);
    
    iBusGoto = [UIImage imageNamed:@"goto.png"];
    ivBusGoto = [[UIImageView alloc]initWithImage:iBusGoto ];
    ivBusGoto.frame = CGRectMake(5, 160, 24, 24);
    
    iBusReturn = [UIImage imageNamed:@"return.png"];
    ivBusReturn = [[UIImageView alloc]initWithImage:iBusReturn ];
    
    
    // Cac nhan thay doi gia tri
    // NHAN
    lBusNumber = [[UILabel alloc] initWithFrame:CGRectMake(135, 10, 200, 20)];
    [lBusNumber setText:self.busO.sBusNumber];
    lBusNumber.font = [UIFont boldSystemFontOfSize:13];
    [lBusNumber setTextColor:[UIColor redColor]];
    
    lTimeBegin = [[UILabel alloc] initWithFrame:CGRectMake(115, 40, 200, 20)];
    [lTimeBegin setText:self.busO.sBusBegin];
    lTimeBegin.font = [UIFont boldSystemFontOfSize:13];
    [lTimeBegin setTextColor:[UIColor redColor]];
    
    lTimeFinish = [[UILabel alloc] initWithFrame:CGRectMake(105, 70, 200, 20)];
    [lTimeFinish setText:self.busO.sBusFinish];
    lTimeFinish.font = [UIFont boldSystemFontOfSize:13];
    [lTimeFinish setTextColor:[UIColor redColor]];
    
    lBusType = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 200, 20)];
    [lBusType setText:self.busO.sBusType];
    lBusType.font = [UIFont boldSystemFontOfSize:13];
    [lBusType setTextColor:[UIColor redColor]];
    
    lBusPrice = [[UILabel alloc] initWithFrame:CGRectMake(90, 130, 200, 20)];
    [lBusPrice setText:self.busO.sBusPrice];
    lBusPrice.font = [UIFont boldSystemFontOfSize:13];
    [lBusPrice setTextColor:[UIColor redColor]];
    
    // Text
    // Text Goto
    CGSize sizeGoto = [self.busO.sBusGoto sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(280, 2000)];
    
    tBusGoto = [[UITextView alloc] initWithFrame:CGRectMake(10, 190, 300, sizeGoto.height + 10)];
    [tBusGoto setFont:[UIFont systemFontOfSize:12]];
    [tBusGoto setText:self.busO.sBusGoto];
    [tBusGoto setEditable:NO];
    
    // Nhan return va IMG return
    ivBusReturn.frame = CGRectMake(5, 190 + sizeGoto.height + 10 , 24, 24);
    lsBusReturn = [[UILabel alloc] initWithFrame:CGRectMake(35, 190 + sizeGoto.height + 10 , 200, 20)];
    [lsBusReturn setText:@"Lượt về:  "];
    lsBusReturn.font = [UIFont boldSystemFontOfSize:13];
    
    
    // Text Return
    CGSize sizeReturn = [self.busO.sBusReturn sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(280, 2000)];
    
    tBusReturn = [[UITextView alloc] initWithFrame:CGRectMake(10, 190 + sizeGoto.height + 10 + 35, 300, sizeReturn.height + 10)];
    [tBusReturn setText:self.busO.sBusReturn];
    [tBusReturn setEditable:NO];
    
    [self.myScroll setContentSize:CGSizeMake(self.myScroll.frame.size.width, 190 + sizeGoto.height + 30 + 35 + sizeReturn.height + 10)];
    
    [self.myScroll setShowsVerticalScrollIndicator:NO];
    [self.myScroll addSubview:lsBusNumber];
    [self.myScroll addSubview:lsTimeBegin];
    [self.myScroll addSubview:lsTimeFinish];
    [self.myScroll addSubview:lsBusType];
    [self.myScroll addSubview:lsBusPrice];
    [self.myScroll addSubview:lsBusGoto];
    [self.myScroll addSubview:lsBusReturn];
    [self.myScroll addSubview:ivBusNumber];
    [self.myScroll addSubview:ivTimeBegin];
    [self.myScroll addSubview:ivTimeFinish];
    [self.myScroll addSubview:ivBustype];
    [self.myScroll addSubview:ivBusPrice];
    [self.myScroll addSubview:ivBusGoto];
    [self.myScroll addSubview:ivBusReturn];
    [self.myScroll addSubview:lBusNumber];
    [self.myScroll addSubview:lTimeBegin];
    [self.myScroll addSubview:lTimeFinish];
    [self.myScroll addSubview:lBusType];
    [self.myScroll addSubview:lBusPrice];
    [self.myScroll addSubview:lBusGoto];
    [self.myScroll addSubview:lBusReturn];
    [self.myScroll addSubview:tBusGoto];
    [self.myScroll addSubview:tBusReturn];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"MapBusView"]) {
        MapBusViewController *mapBus = (MapBusViewController *)[[segue destinationViewController] topViewController];
        mapBus.idMapBus = self.busO.sBusNumber;
    }
}

@end
