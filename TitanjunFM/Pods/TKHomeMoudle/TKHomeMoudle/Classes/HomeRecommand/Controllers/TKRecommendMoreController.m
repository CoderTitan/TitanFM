//
//  TKRecommendMoreController.m
//  MoreModel
//
//  Created by quanjunt on 2018/9/19.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import "TKRecommendMoreController.h"
#import "TKRecommandViewModel.h"
#import "TKHomeRecommandDefine.h"
#import "TKNominateEditorCell.h"

@interface TKRecommendMoreController ()
@property (nonatomic, strong)NSArray <TKNominateEditorModel *> *editorMs;

@end

@implementation TKRecommendMoreController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.navTitle;
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 88.0;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TKNominateEditorCell" bundle:[NSBundle bundleForClass:[self class]]] forCellReuseIdentifier:@"EditorCell"];
    
    //加载数据
    [[TKRecommandViewModel shareInstance] getRecommendEditorList:^(NSArray<TKNominateEditorModel *> * _Nonnull editorMs, NSError * _Nonnull error) {
        self.editorMs = editorMs;
        [self.tableView reloadData];
    }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.editorMs.count;;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TKNominateEditorCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EditorCell"];
    
    TKNominateEditorModel *model = self.editorMs[indexPath.row];
    cell.model = model;
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TKNominateEditorModel *model = self.editorMs[indexPath.row];
    NSString *albumID = [NSString stringWithFormat:@"%zd", model.albumId];
    UINavigationController *nav = self.navigationController;
    kJumpToAlbumDetail(albumID, nav)
}

@end
