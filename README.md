# MKRefresh
无聊，自己弄个iOS下拉刷新原理玩玩


 //创建下拉控件
    MKHeadRefreshView *refreshHeadView = [[MKHeadRefreshView alloc]init];
    
    [self.tableView addSubview:refreshHeadView];
    
    __block MKHeadRefreshView *blockHeadView = refreshHeadView;
    refreshHeadView.refresh = ^(){
        //此处是请求网络数据的地方：
    };
    
    MKFooterRefreshView *footerRefreshView = [[MKFooterRefreshView alloc]init];
    [self.tableView addSubview:footerRefreshView];
    __block MKFooterRefreshView *blockFooterView = footerRefreshView;
    footerRefreshView.refreshMoreData = ^() {
               //此处是请求网络数据的地方：
    };
    
    self.tableView.tableFooterView = [[UIView alloc]init];//消除tableView的FooterView的影响


![image](https://github.com/MikeWang1010/MKRefresh/blob/master/MKRefresh/headRefreshView.png)
![image](https://github.com/MikeWang1010/MKRefresh/blob/master/MKRefresh/footerRefreshView.png)
