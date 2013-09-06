//
//  WebtoonDetailViewController.m
//  Hippo
//
//  Created by 전수열 on 13. 9. 6..
//  Copyright (c) 2013년 Joyfl. All rights reserved.
//

#import "WebtoonDetailViewController.h"
#import "Episode.h"
#import "EpisodeCell.h"

@implementation WebtoonDetailViewController

- (void)viewDidLoad
{
	self.view.backgroundColor = [UIColor whiteColor];
	
	self.navigationItem.title = self.webtoon.title;
	
	UIBarButtonItem *subscribeButton = [[UIBarButtonItem alloc] initWithTitle:self.webtoon.subscribed.boolValue ? @"구독중" : @"구독하기" style:UIBarButtonItemStylePlain target:self action:@selector(subscribeButtonDidTouchUpInside)];
	self.navigationItem.rightBarButtonItem = subscribeButton;
	
	self.detailView = [[WebtoonDetailView alloc] init];
	self.detailView.webtoon = self.webtoon;
	self.detailView.frame = CGRectMake( 0, 64, UIScreenWidth, self.detailView.frame.size.height );
	[self.view addSubview:self.detailView];
	
	self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64 + self.detailView.frame.size.height, UIScreenWidth, UIScreenHeight - 112 - self.detailView.frame.size.height)];
	self.tableView.delegate = self;
	self.tableView.dataSource = self;
	[self.view addSubview:self.tableView];
	
	self.episodes = [NSMutableArray array];
	
	[self compareRevision];
}

- (void)subscribeButtonDidTouchUpInside
{
	
}


#pragma mark -
#pragma mark

- (void)compareRevision
{
	NSString *api = [NSString stringWithFormat:@"/webtoon/%@/revision", self.webtoon.id];
	[[APILoader sharedLoader] api:api method:@"GET" parameters:nil success:^(id response) {
		NSNumber *revision = [response objectForKey:@"revision"];
		NSLog( @"Episode Revision (local/remote) : %@ / %@", self.webtoon.revision, revision );
		if( [self.webtoon.revision integerValue] < [revision integerValue] )
		{
			[self loadEpisodes];
			self.webtoon.revision = revision;
			[[AppDelegate appDelegate] saveContext];
		}
		else
		{
			self.episodes = [[Episode filter:@"webtoon_id==%@", self.webtoon.id] mutableCopy];
			[self.tableView reloadData];
		}
		
	} failure:^(NSInteger statusCode, NSInteger errorCode, NSString *message) {
		showErrorAlert();
	}];
}

- (void)loadEpisodes
{
	NSString *api = [NSString stringWithFormat:@"/webtoon/%@/episodes", self.webtoon.id];
	[[APILoader sharedLoader] api:api method:@"GET" parameters:nil success:^(id response) {
		self.bookmark = [[response objectForKeyNotNull:@"bookmark"] integerValue];
		NSArray *data = [response objectForKey:@"data"];
		for( NSDictionary *episodeData in data )
		{
			Episode *episode = [[Episode filter:@"id==%@", [episodeData objectForKey:@"id"]] lastObject];
			if( !episode ) {
				episode = [Episode insert];
			}
			[episode safeSetValuesForKeysWithDictionary:episodeData];
			[self.episodes addObject:episode];
		}
		[[AppDelegate appDelegate] saveContext];
		[self.tableView reloadData];
		
	} failure:^(NSInteger statusCode, NSInteger errorCode, NSString *message) {
		showErrorAlert();
	}];
}


#pragma mark -
#pragma mark UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.episodes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *cellId = @"cellId";
	EpisodeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
	if( !cell ) {
		cell = [[EpisodeCell alloc] initWithReuseIdentifier:cellId];
	}
	cell.episode = [self.episodes objectAtIndex:indexPath.row];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
