//
//  Filter.swift
//  YoutubeKit
//
//  Created by Ryo Ishikawa on 12/30/2017
//

// MARK: - Namespace
public enum Filter {}

extension Filter {
    public enum VideoList: QueryParameterable {
        case chart
        case id(String)
        case myRating(MyRating)
        
        public var keyValue: (key: String, value: Any) {
            switch self {
            case .chart:
                return ("chart", "mostPopular")
            case .id(let videoID):
                return ("id", videoID)
            case .myRating(let myRating):
                return ("myRating", myRating.rawValue)
            }
        }
    }
}

extension Filter {
    public enum ActivityList: QueryParameterable {
        case channelID(String)
        case home(Bool)
        case mine(Bool)
        
        public var keyValue: (key: String, value: Any) {
            switch self {
            case .channelID(let id):
                return ("channelId", id)
            case .home(let isOn):
                return ("home", isOn.literalString)
            case .mine(let isOn):
                return ("mine", isOn.literalString)
            }
        }
    }
}

extension Filter {
    public enum ChannelList: QueryParameterable {
        case categoryID(String)
        case userName(String)
        case id(String)
        case managedByMe(Bool)
        case mine(Bool)
        
        public var keyValue: (key: String, value: Any) {
            switch self {
            case .categoryID(let id):
                return ("categoryId", id)
            case .userName(let name):
                return ("forUsername", name)
            case .id(let id):
                return ("id", id)
            case .managedByMe(let isOn):
                return ("managedByMe", isOn.literalString)
            case .mine(let isOn):
                return ("mine", isOn.literalString)
            }
        }
    }
}

extension Filter {
    public enum ChannelSectionsList: QueryParameterable {
        case channelID(String)
        case id(String)
        case mine(Bool)
        
        public var keyValue: (key: String, value: Any) {
            switch self {
            case .channelID(let id):
                return ("channelId", id)
            case .id(let id):
                return ("id", id)
            case .mine(let isOn):
                return ("mine", isOn.literalString)
            }
        }
    }
}

extension Filter {
    public enum VideoCategoriesList: QueryParameterable {
        case id(String)
        case regionCode(String)
        
        public var keyValue: (key: String, value: Any) {
            switch self {
            case .id(let id):
                return ("id", id)
            case .regionCode(let code):
                return ("regionCode", code)
            }
        }
    }
}

extension Filter {
    public enum SearchList: QueryParameterable {
        case forContentOwner(Bool)
        case forMine(Bool)
        case relatedToVideoID(String)
        
        public var keyValue: (key: String, value: Any) {
            switch self {
            case .forContentOwner(let isOn):
                return ("forContentOwner", isOn.literalString)
            case .forMine(let isOn):
                return ("forMine", isOn.literalString)
            case .relatedToVideoID(let videoID):
                return ("relatedToVideoId", videoID)
            }
        }
    }
}

extension Filter {
    public enum GuideCategoriesList: QueryParameterable {
        case id(String)
        case regionCode(String)
        
        public var keyValue: (key: String, value: Any) {
            switch self {
            case .id(let id):
                return ("id", id)
            case .regionCode(let code):
                return ("regionCode", code)
            }
        }
    }
}

extension Filter {
    public enum SubscriptionsList: QueryParameterable {
        case channelID(String)
        case id(String)
        case mine(Bool)
        case mySubscriptions(Bool)
        
        public var keyValue: (key: String, value: Any) {
            switch self {
            case .channelID(let id):
                return ("channelId", id)
            case .id(let id):
                return ("id", id)
            case .mine(let isOn):
                return ("mine", isOn.literalString)
            case .mySubscriptions(let isOn):
                return ("mySubscriptions", isOn.literalString)
            }
        }
    }
}

extension Filter {
    public enum PlaylistsList: QueryParameterable {
        case channelID(String)
        case id(String)
        case mine(Bool)
        
        public var keyValue: (key: String, value: Any) {
            switch self {
            case .channelID(let id):
                return ("channelId", id)
            case .id(let id):
                return ("id", id)
            case .mine(let isOn):
                return ("mine", isOn.literalString)
            }
        }
    }
}

extension Filter {
    public enum PlaylistItemsList: QueryParameterable {
        case id(String)
        case playlistID(String)
        
        public var keyValue: (key: String, value: Any) {
            switch self {
            case .id(let id):
                return ("id", id)
            case .playlistID(let id):
                return ("playlistId", id)
            }
        }
    }
}

extension Filter {
    public enum CommentThreadsList: QueryParameterable {
        case allThreadsRelatedToChannelID(String)
        case channelID(String)
        case id(String)
        case videoID(String)
        
        public var keyValue: (key: String, value: Any) {
            switch self {
            case .allThreadsRelatedToChannelID(let id):
                return ("allThreadsRelatedToChannelId", id)
            case .channelID(let id):
                return ("channelId", id)
            case .id(let id):
                return ("id", id)
            case .videoID(let id):
                return ("videoId", id)
            }
        }
    }
}

extension Filter {
    public enum CommentList: QueryParameterable {
        case id(String)
        case parentID(String)
        
        public var keyValue: (key: String, value: Any) {
            switch self {
            case .id(let id):
                return ("id", id)
            case .parentID(let id):
                return ("parentId", id)
            }
        }
    }
}
