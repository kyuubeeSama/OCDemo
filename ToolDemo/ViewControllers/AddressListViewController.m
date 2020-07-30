//
//  AddressListViewController.m
//  ToolDemo
//
//  Created by liuqingyuan on 2018/4/26.
//  Copyright © 2018年 liuqingyuan. All rights reserved.
//

#import "AddressListViewController.h"
#import "ThirdHeader.h"
#import "Tool.h"
#import <ContactsUI/ContactsUI.h>
#import <Contacts/Contacts.h>
#import <AddressBook/AddressBook.h>

@interface AddressListViewController () <UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, retain) NSMutableArray *listArr;
@property(nonatomic, retain) UITableView *mainTable;

@end

@implementation AddressListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.listArr = [[NSMutableArray alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"通讯录";
    [self createTableView];
    [self registerAddressList];

}

- (void)registerAddressList {
    // 注册通讯录
    [self requestAuthorizationAddressBook];
}

- (void)requestAuthorizationAddressBook {
        CNAuthorizationStatus authorizationStatus = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
        if (authorizationStatus == CNAuthorizationStatusNotDetermined) {
            CNContactStore *contactStore = [[CNContactStore alloc] init];
            [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError *_Nullable error) {
                if (granted) {
                    [self getData];
                } else {
                    NSLog(@"授权失败, error=%@", error);
                }
            }];
        } else if (authorizationStatus == CNAuthorizationStatusAuthorized) {
            [self getData];
        }
}

- (void)getData {
        // 获取指定的字段,并不是要获取所有字段，需要指定具体的字段
        NSArray *keysToFetch = @[CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey];
        CNContactFetchRequest *fetchRequest = [[CNContactFetchRequest alloc] initWithKeysToFetch:keysToFetch];
        CNContactStore *contactStore = [[CNContactStore alloc] init];
        [contactStore enumerateContactsWithFetchRequest:fetchRequest error:nil usingBlock:^(CNContact *_Nonnull contact, BOOL *_Nonnull stop) {
            NSLog(@"-------------------------------------------------------");
            NSString *givenName = contact.givenName;
            NSString *familyName = contact.familyName;
            NSLog(@"givenName=%@, familyName=%@", givenName, familyName);


            NSArray *phoneNumbers = contact.phoneNumbers;
            NSString *mobile = @"无号码";
            for (CNLabeledValue *labelValue in phoneNumbers) {
                NSString *label = labelValue.label;
                CNPhoneNumber *phoneNumber = labelValue.value;
                NSLog(@"label=%@, phone=%@", label, phoneNumber.stringValue);
                if (phoneNumber.stringValue.length > 0) {
                    mobile = phoneNumber.stringValue;
                } else {
                    mobile = @"无号码";
                }
            }
            NSDictionary *dic = @{@"name": [NSString stringWithFormat:@"%@%@", familyName, givenName], @"mobile": mobile};
            [self.listArr addObject:dic];
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.mainTable reloadData];
        });
}

- (void)createTableView {
    self.mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    [self.view addSubview:self.mainTable];
    self.mainTable.estimatedRowHeight = 0;
    self.mainTable.estimatedSectionHeaderHeight = 0;
    self.mainTable.estimatedSectionFooterHeight = 0;
    self.mainTable.dataSource = self;
    self.mainTable.delegate = self;
    [self.mainTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top).offset(20 + (SCREEN_TOP));
        make.bottom.equalTo(self.view.mas_bottom).offset(SCREEN_BOTTOM);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.listArr[indexPath.row];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    cell.textLabel.text = dic[@"name"];
    cell.detailTextLabel.text = dic[@"mobile"];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
