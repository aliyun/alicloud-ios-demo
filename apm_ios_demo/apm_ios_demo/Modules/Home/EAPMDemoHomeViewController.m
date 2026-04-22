#import "EAPMDemoHomeViewController.h"

#import "EAPMDemoSettingsViewController.h"
#import "EAPMDemoHomeUI.h"
#import "../Shared/EAPMDemoUIComponents.h"
#import "../Shared/EAPMDemoOverlayPresenter.h"
#import "../Shared/EAPMDemoUIStyleGuide.h"
#import "EAPMDemoCrashAnalysis.h"
#import "EAPMDemoMemory.h"
#import "EAPMDemoPerformance.h"
#import "EAPMDemoRemoteLog.h"

static NSString * const EAPMDemoHeroCellReuseIdentifier = @"EAPMDemoHeroCell";
static NSString * const EAPMDemoActionCellReuseIdentifier = @"EAPMDemoActionCell";
static NSString * const EAPMDemoSectionHeaderReuseIdentifier = @"EAPMDemoSectionHeader";

@interface EAPMDemoHeroHeaderCell : UICollectionViewCell

- (void)configureWithInfoText:(NSString *)text settingsHandler:(nullable EAPMDemoHomeActionHandler)settingsHandler;

@end

@interface EAPMDemoActionCardCell : UICollectionViewCell

- (void)configureWithItem:(EAPMDemoHomeActionItem *)item;
- (void)setCardHighlighted:(BOOL)highlighted;

@end

@interface EAPMDemoSectionHeaderReusableView : UICollectionReusableView

- (void)configureWithTitle:(NSString *)title;

@end

@interface EAPMDemoHomeViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray<EAPMDemoHomeSectionModel *> *sections;
@property (nonatomic, copy) NSString *infoBannerText;
@property (nonatomic, assign) BOOL hasPresentedLaunchBlockingAlert;

@end

@implementation EAPMDemoHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithRed:0xF3 / 255.0 green:0xF4 / 255.0 blue:0xF8 / 255.0 alpha:1.0];

    [self buildData];
    [self buildViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self presentLaunchBlockingAlertIfNeeded];
}

- (void)buildData {
    self.infoBannerText = @"触发相关事件，并在 EMAS 控制台 查看上报数据";
    self.sections = @[
        [EAPMDemoCrashAnalysis sectionWithPresenter:self],
        [EAPMDemoPerformance sectionWithPresenter:self],
        [EAPMDemoMemory sectionWithPresenter:self],
        [EAPMDemoRemoteLog sectionWithPresenter:self],
    ];
}

- (void)buildViews {
    EAPMDemoGradientBackgroundView *backgroundView = [[EAPMDemoGradientBackgroundView alloc] init];
    backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:backgroundView];

    UICollectionViewCompositionalLayout *layout = [[UICollectionViewCompositionalLayout alloc] initWithSectionProvider:^NSCollectionLayoutSection * _Nullable(NSInteger sectionIndex, id<NSCollectionLayoutEnvironment>  _Nonnull environment) {
        if (sectionIndex == 0) {
            NSCollectionLayoutSize *itemSize = [NSCollectionLayoutSize sizeWithWidthDimension:[NSCollectionLayoutDimension fractionalWidthDimension:1.0]
                                                                              heightDimension:[NSCollectionLayoutDimension absoluteDimension:332.0]];
            NSCollectionLayoutItem *item = [NSCollectionLayoutItem itemWithLayoutSize:itemSize];
            NSCollectionLayoutGroup *group = [NSCollectionLayoutGroup horizontalGroupWithLayoutSize:itemSize subitems:@[item]];
            NSCollectionLayoutSection *section = [NSCollectionLayoutSection sectionWithGroup:group];
            section.contentInsets = NSDirectionalEdgeInsetsMake(0.0, 0.0, 18.0, 0.0);
            return section;
        }

        NSCollectionLayoutSize *itemSize = [NSCollectionLayoutSize sizeWithWidthDimension:[NSCollectionLayoutDimension fractionalWidthDimension:0.5]
                                                                          heightDimension:[NSCollectionLayoutDimension absoluteDimension:EAPMDemoUISecondaryActionHeight]];
        NSCollectionLayoutItem *item = [NSCollectionLayoutItem itemWithLayoutSize:itemSize];

        NSCollectionLayoutSize *groupSize = [NSCollectionLayoutSize sizeWithWidthDimension:[NSCollectionLayoutDimension fractionalWidthDimension:1.0]
                                                                           heightDimension:[NSCollectionLayoutDimension absoluteDimension:EAPMDemoUISecondaryActionHeight]];
        NSCollectionLayoutGroup *group = [NSCollectionLayoutGroup horizontalGroupWithLayoutSize:groupSize subitem:item count:2];
        group.interItemSpacing = [NSCollectionLayoutSpacing fixedSpacing:6.0];

        NSCollectionLayoutSection *section = [NSCollectionLayoutSection sectionWithGroup:group];
        section.contentInsets = NSDirectionalEdgeInsetsMake(0.0, EAPMDemoUIHorizontalInset, 12.0, EAPMDemoUIHorizontalInset);
        section.interGroupSpacing = 6.0;

        NSCollectionLayoutBoundarySupplementaryItem *header = [NSCollectionLayoutBoundarySupplementaryItem boundarySupplementaryItemWithLayoutSize:[NSCollectionLayoutSize sizeWithWidthDimension:[NSCollectionLayoutDimension fractionalWidthDimension:1.0]
                                                                                                                                 heightDimension:[NSCollectionLayoutDimension absoluteDimension:28.0]]
                                                                                                                                      elementKind:UICollectionElementKindSectionHeader
                                                                                                                                           alignment:NSRectAlignmentTop];
        header.contentInsets = NSDirectionalEdgeInsetsMake(0.0, 0.0, 6.0, 0.0);
        section.boundarySupplementaryItems = @[header];

        return section;
    }];

    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    _collectionView.backgroundColor = UIColor.clearColor;
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [_collectionView registerClass:[EAPMDemoHeroHeaderCell class] forCellWithReuseIdentifier:EAPMDemoHeroCellReuseIdentifier];
    [_collectionView registerClass:[EAPMDemoActionCardCell class] forCellWithReuseIdentifier:EAPMDemoActionCellReuseIdentifier];
    [_collectionView registerClass:[EAPMDemoSectionHeaderReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:EAPMDemoSectionHeaderReuseIdentifier];
    [self.view addSubview:_collectionView];

    [NSLayoutConstraint activateConstraints:@[
        [backgroundView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [backgroundView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [backgroundView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [backgroundView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],

        [_collectionView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [_collectionView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [_collectionView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [_collectionView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
    ]];
}

- (void)handleSettingsButtonTapped {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    EAPMDemoSettingsViewController *settingsViewController = [[EAPMDemoSettingsViewController alloc] init];
    [self.navigationController pushViewController:settingsViewController animated:YES];
}

- (void)presentLaunchBlockingAlertIfNeeded {
    if (self.hasPresentedLaunchBlockingAlert ||
        self.launchBlockingAlertTitle.length == 0 ||
        self.launchBlockingAlertMessage.length == 0 ||
        self.presentedViewController) {
        return;
    }

    self.hasPresentedLaunchBlockingAlert = YES;
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf || strongSelf.presentedViewController) {
            return;
        }

        [EAPMDemoAlertPresenter presentAlertFrom:strongSelf
                                           title:strongSelf.launchBlockingAlertTitle
                                         message:strongSelf.launchBlockingAlertMessage
                                         actions:@[
            [EAPMDemoAlertAction actionWithTitle:@"确认退出"
                                           style:EAPMDemoAlertActionStylePrimary
                                         handler:strongSelf.launchBlockingAlertActionHandler]
        ]];
    });
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.sections.count + 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return self.sections[section - 1].items.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        EAPMDemoHeroHeaderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:EAPMDemoHeroCellReuseIdentifier forIndexPath:indexPath];
        __weak typeof(self) weakSelf = self;
        [cell configureWithInfoText:self.infoBannerText settingsHandler:^{
            [weakSelf handleSettingsButtonTapped];
        }];
        return cell;
    }

    EAPMDemoActionCardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:EAPMDemoActionCellReuseIdentifier forIndexPath:indexPath];
    EAPMDemoHomeActionItem *item = self.sections[indexPath.section - 1].items[indexPath.item];
    [cell configureWithItem:item];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    EAPMDemoSectionHeaderReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:EAPMDemoSectionHeaderReuseIdentifier forIndexPath:indexPath];
    [view configureWithTitle:self.sections[indexPath.section - 1].title];
    return view;
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    if ([cell isKindOfClass:[EAPMDemoActionCardCell class]]) {
        [(EAPMDemoActionCardCell *)cell setCardHighlighted:YES];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    if ([cell isKindOfClass:[EAPMDemoActionCardCell class]]) {
        [(EAPMDemoActionCardCell *)cell setCardHighlighted:NO];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return;
    }

    EAPMDemoHomeActionItem *item = self.sections[indexPath.section - 1].items[indexPath.item];
    [item performAction];
}

@end

@interface EAPMDemoHeroHeaderCell ()

@property (nonatomic, strong) EAPMDemoHeroHeaderView *heroHeaderView;

@end

@implementation EAPMDemoHeroHeaderCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.clearColor;
        _heroHeaderView = [[EAPMDemoHeroHeaderView alloc] init];
        _heroHeaderView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_heroHeaderView];

        [NSLayoutConstraint activateConstraints:@[
            [_heroHeaderView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor],
            [_heroHeaderView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor],
            [_heroHeaderView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor],
            [_heroHeaderView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor],
        ]];
    }
    return self;
}

- (void)configureWithInfoText:(NSString *)text settingsHandler:(nullable EAPMDemoHomeActionHandler)settingsHandler {
    [self.heroHeaderView configureWithInfoText:text settingsHandler:settingsHandler];
}

@end

@interface EAPMDemoActionCardCell ()

@property (nonatomic, strong) EAPMDemoSecondaryActionButton *cardView;

@end

@implementation EAPMDemoActionCardCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.clearColor;
        _cardView = [[EAPMDemoSecondaryActionButton alloc] init];
        _cardView.translatesAutoresizingMaskIntoConstraints = NO;
        _cardView.userInteractionEnabled = NO;
        [self.contentView addSubview:_cardView];

        [NSLayoutConstraint activateConstraints:@[
            [_cardView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor],
            [_cardView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor],
            [_cardView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor],
            [_cardView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor],
        ]];
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [self.cardView setActionHighlighted:NO];
}

- (void)configureWithItem:(EAPMDemoHomeActionItem *)item {
    [self.cardView configureWithTitle:item.title];
}

- (void)setCardHighlighted:(BOOL)highlighted {
    [self.cardView setActionHighlighted:highlighted];
}

@end

@interface EAPMDemoSectionHeaderReusableView ()

@property (nonatomic, strong) EAPMDemoSectionHeaderView *headerView;

@end

@implementation EAPMDemoSectionHeaderReusableView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _headerView = [[EAPMDemoSectionHeaderView alloc] init];
        _headerView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_headerView];

        [NSLayoutConstraint activateConstraints:@[
            [_headerView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
            [_headerView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
            [_headerView.topAnchor constraintEqualToAnchor:self.topAnchor],
            [_headerView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
        ]];
    }
    return self;
}

- (void)configureWithTitle:(NSString *)title {
    [self.headerView configureWithTitle:title];
}

@end
