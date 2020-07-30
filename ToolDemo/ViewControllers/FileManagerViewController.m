//
//  FileManagerViewController.m
//  quanyihui
//
//  Created by liuqingyuan on 2019/3/28.
//  Copyright © 2019 qyhl. All rights reserved.
//

#import "FileManagerViewController.h"
#import "UploadFileTableViewCell.h"
#import "MessageChooseView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "FileTool.h"

@interface FileManagerViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *mainTable;
@property(nonatomic,strong)NSMutableArray *listArr;
@property(nonatomic,strong)NSMutableArray *dataArr;
@property(nonatomic,assign)int fileType;

@end

@implementation FileManagerViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setNav];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.listArr[0]=@[];
    [self.mainTable reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.listArr = [[NSMutableArray alloc]initWithArray:@[@[],@[],@[],@[],@[]]];
    self.fileType = 0;
    [self makeUI];
    [self getFileList];
}

-(void)getFileList
{
    NSArray *arr = self.listArr[(NSUInteger)self.fileType];
    if (arr.count==0) {
        FileTool *tool = [[FileTool alloc]init];
        [self beginProgressWithTitle:@"本地文件较多，请稍等"];
        if (self.fileType == 0) {
            tool.getImageFinishBlock = ^(NSMutableArray * _Nonnull array) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self endProgress];
                    NSLog(@"获取到图片数量是%ld",array.count);
                     self.listArr[0]=array;
                     [self.mainTable reloadData];
                });
            };
            [tool GetDocumentsFilesWithType:QYFileTypeImage WithNum:0];
        }else{
            switch (self.fileType) {
                case 1:
                {
                    NSMutableArray *dataArr = [tool GetDocumentsFilesWithType:QYFileTypeWord WithNum:0];
                    self.listArr[1] = dataArr;
                }
                    break;
                case 2:
                {
                    NSMutableArray *dataArr = [tool GetDocumentsFilesWithType:QYFileTypeExcel WithNum:0];
                    self.listArr[2] = dataArr;
                }
                    break;
                case 3:
                {
                    NSMutableArray *dataArr = [tool GetDocumentsFilesWithType:QYFileTypePPT WithNum:0];
                    self.listArr[3] = dataArr;
                }
                    break;
                default:
                {
                    NSMutableArray *dataArr = [tool GetDocumentsFilesWithType:QYFileTypePDF WithNum:0];
                    self.listArr[4] = dataArr;
                }
                    break;
            }
            [self.mainTable reloadData];
            [self endProgress];
        }
    }else{
        [self.mainTable reloadData];
    }
}

-(void)setNav{
    self.navigationController.title = @"文件选择";
}

-(void)makeUI{
    NSArray *titleArr = @[@"IMAGE",@"WORD",@"XLS",@"PPT",@"PDF"];
    MessageChooseView *chooseView = [[MessageChooseView alloc]initWithFrame:CGRectMake(0, TOP_HEIGHT, SCREEN_WIDTH, 45) WithArr:titleArr];
    chooseView.chooseBlock = ^(int index) {
        [self.dataArr removeAllObjects];
        self.fileType = index;
        [self getFileList];
    };
    [self.view addSubview:chooseView];
    
    self.mainTable=[[UITableView alloc]initWithFrame:CGRectMake(0, (TOP_HEIGHT)+45, SCREEN_WIDTH, SCREEN_HEIGHT-45-(TOP_HEIGHT)) style:UITableViewStylePlain];
    [self.view addSubview:self.mainTable];
    self.mainTable.dataSource=self;
    self.mainTable.delegate=self;
    self.mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.mainTable registerNib:[UINib nibWithNibName:@"UploadFileTableViewCell" bundle:nil] forCellReuseIdentifier:@"FileCell"];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    self.dataArr = self.listArr[(NSUInteger)self.fileType];
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QYFileModel *model = self.dataArr[(NSUInteger)indexPath.row];
    static NSString *CellIdentifier = @"Cell";
    BOOL nibsRegistered = NO;
    if (!nibsRegistered) {
        UINib *nib = [UINib nibWithNibName:NSStringFromClass([UploadFileTableViewCell class]) bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
        nibsRegistered = YES;
    }
    UploadFileTableViewCell *cell = (UploadFileTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.uploadBlock = ^(int indexpath) {
        NSString *path_sandox = NSHomeDirectory();
        //设置一个图片的存储路径
        NSString *imagePath = [path_sandox stringByAppendingString:[NSString stringWithFormat:@"/Documents/%@",model.filename]];
        NSString *filePath = [NSString stringWithFormat:@"file://%@",imagePath];
        model.filePath = filePath;
        if (self.fileType == 0) {
            // 图片
            // 将图片移动到documents下面，同时获取到图片内容
            //把图片直接保存到指定的路径（同时应该把图片的路径imagePath存起来，下次就可以直接用来取）
            [[PHImageManager defaultManager]requestImageDataForAsset:model.set options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                UIImage *fullImg = [UIImage imageWithData:imageData];
                if([UIImageJPEGRepresentation(fullImg, 1) writeToFile:imagePath atomically:YES]){
                }

            }];
        }else{
            // 普通文件，上传文件
        }
    };
    switch (self.fileType) {
        case 0:
        {
            [model getImageAndInfoComplete:^{
                cell.icoImg.image = model.image;
                cell.SizeLab.text = model.size;
            }];
        }
            break;
         case 1:
            cell.icoImg.image = [UIImage imageNamed:@"word_ico"];
            break;
            case 2:
            cell.icoImg.image = [UIImage imageNamed:@"xls_ico"];
            break;
        case 3:
            cell.icoImg.image = [UIImage imageNamed:@"ppt_ico"];
            break;
        case 4:
            cell.icoImg.image = [UIImage imageNamed:@"pdf_ico"];
            break;
        default:
            break;
    }
    cell.TitleLab.text = model.filename;
    cell.timeLab.text = model.time;
    if (self.fileType != 0) {
        cell.SizeLab.text = model.size;
    }
    cell.tag = indexPath.row;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (void)didReceiveMemoryWarning
{
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
