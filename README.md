# AppPlaceholder
######前文提要
近期准备重构项目，需要重写一些通用模块，正巧需要设置App异常加载占位图的问题，心血来潮设想是否可以零行代码解决此问题，特在此分享实现思路。

######思路分享
对于App占位图，通常需要考虑的控件有tableView、collectionView和webView，异常加载情况区分为无数据和网络异常等。

既然要实现零代码形式，因此就不能继承原始类重写或添加方法等方式，而是通过对对应控件添加类别（分类）来实现。

简单来说，以tableView为例实现思路为每当tableView调用reloadData进行刷新时，检测此时tableView行数，若行数不为零，正常显示数据。若行数为零，说明无数据显示占位图。

添加占位图的方式有很多种，例如借助tableView的backgroundView或直接以addSubView的方式添加，这里采用的为addSubView方式，尽量避免原生属性的占用。

对于检测tableView数据是否为空，借助tableView的代理dataSource即可。核心代码如下，依次获取tableView所具有的组数与行数，通过isEmpty这个flag标示最后确定是否添加占位图。
```
- (void)checkEmpty {
    BOOL isEmpty = YES;//flag标示
    
    id <UITableViewDataSource> dataSource = self.dataSource;
    NSInteger sections = 1;//默认一组
    if ([dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
        sections = [dataSource numberOfSectionsInTableView:self] - 1;//获取当前TableView组数
    }
    
    for (NSInteger i = 0; i <= sections; i++) {
        NSInteger rows = [dataSource tableView:self numberOfRowsInSection:i];//获取当前TableView各组行数
        if (rows) {
            isEmpty = NO;//若行数存在，不为空
        }
    }
    if (isEmpty) {//若为空，加载占位图
        if (!self.placeholderView) {//若未自定义，展示默认占位图
            [self makeDefaultPlaceholderView];
        }
        self.placeholderView.hidden = NO;
        [self addSubview:self.placeholderView];
    } else {//不为空，隐藏占位图
        self.placeholderView.hidden = YES;
    }
}
```
相应的对于CollectionView亦可通过```numberOfSectionsInCollectionView:```和```collectionView:numberOfItemsInSection```获取其组数和行数，这里就不一一赘述。

需要注意的为webView占位图是否显示的判断，一种情况为webView调用其```webView: didFailLoadWithError:```方法，第二种为webView完成加载显示为空的情况。但存在的一个问题是，webView没有必选的协议方法，或可能根本没有设置代理。因此无法很好的判断webView是否响应其协议方法。因此该demo暂时没有添加webView的占位图，如果有好的想法可以评论指出。

######接下来说最重要的一步，如何实现零行代码添加占位图呢？
其实实现思路非常简单，如果可以让tableView在执行reloadData时自动检测其行数就可以了。也就是我们需要在reloadData原有方法的基础上添加checkEmpty此方法。

这里又能体现到Runtime Method Swizzling的作用了，我们可以通过Method Swizzling替换reloadData方法，给予它新的实现。核心代码如下：
```
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //方法交换，将reloadData实现交换为sure_reloadData
        [self methodSwizzlingWithOriginalSelector:@selector(reloadData) bySwizzledSelector:@selector(sure_reloadData)];
    });
}

- (void)sure_reloadData {
    [self checkEmpty];
    [self sure_reloadData];
}
```
这样就可以实现reloadData的同时检测行数从而判断是否显示占位图的功能。
这里采用了上篇文章[《Runtime Method Swizzling开发实例汇总》](http://www.jianshu.com/p/f6dad8e1b848)的代码用例类```NSObject+Swizzling.h```，因此该篇文章也算上篇文章的延续，为Runtime Method Swizzling的另一种用例。感兴趣的朋友可以前往阅读更多的实用用例。

为实现零代码的效果，代码中已添加了placeholder视图的默认样式，如图所示：
![占位图样式](http://upload-images.jianshu.io/upload_images/1767950-359ca5b4d9ce8452.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

若要实现效果图中点击图标重新刷新效果，需要让tableView调用reloadBlock，因为数据的刷新大多是不同的，所以具体刷新执行代码还是需要自己手动设置的。若不需要，则无需添加此操作。
```
[_tableView setReloadBlock:^{
      //刷新操作
}];
```
如果需要自定制占位视图样式也非常简单，因占位图样式比较统一，所以可直接修改```SurePlaceholderView```占位图类以达到自己想要的效果，再而在```UITableView+Sure_Placeholder.h```、```UICollectionView+Sure_Placeholder.h```、```UIWebView+Sure_Placeholder.h```类别中均外漏了placeholderView属性，将其赋值为新的视图亦可。

以tableView为例，可以通过如下方式进行修改
```
_tableView.placeholderView =[[CustomPlaceholderView alloc]initWithFrame:_tableView.bounds];
```

同样的对于无数据与无网络的效果切换，也可以通过网络是否可用的标示来进行展示不同的占位图。例如
```
if (is_Net_Available) {
   _tableView.placeholderView = [[CustomPlaceholderView alloc]initWithFrame:_tableView.bounds];
 } else {
   _tableView.placeholderView = [[NetNoAvailableView alloc]initWithFrame:_tableView.bounds];
}
```
为方便大家阅读和修改，demo已上传github。

下载链接如下:
[零行代码为App添加无数据占位图🔗](https://github.com/LSure/AppPlaceholder)

既然为零代码，因此使用方法将Sure_Placeholder文件夹拖入工程即可。有任何问题大家可以评论指出。

目前已修复问题与功能添加
修复固定数据多组显示问题
修复首次网络请求未完成占位图显示问题
因tableView、collectionView在创建后系统会默认调用一次reloadData，所以会出现网络请求未完成即展示占位图的问题。类别中新增加属性firstReload（首次加载）加以限制，若希望在首次网络请求未完成时不显示占位图，可将firstReload置为YES即可。
```
_tableView.firstReload = YES;
```
代码持续更新中，欢迎大家Clone！
