//
//  Part.swift
//  YoutubeKit
//
//  Created by Ryo Ishikawa on 12/30/2017
//

// MARK: - Namespace
public enum Part {}

extension Part {
    public enum VideoList: String {
        case id
        case snippet
        case contentDetails
        case statistics
        case status
    }
}

extension Part {
    public enum ActivityList: String {
        case id
        case snippet
        case contentDetails
    }
}

extension Part {
    public enum ActivityInsert: String {
        case snippet
        case contentDetails
    }
}

extension Part {
    public enum CaptionList: String {
        case id
        case snippet
    }
}

extension Part {
    public enum ChannelList: String {
        case id
        case snippet
        case brandingSettings
        case contentDetails
        case invideoPromotion
        case statistics
        case topicDetails
    }
}

extension Part {
    public enum ChannelSectionsList: String {
        case contentDetails
        case id
        case localizations
        case snippet
        case targeting
    }
}

extension Part {
    public enum I18nLanguagesList: String {
        case snippet
    }
}

extension Part {
    public enum I18nRegionsList: String {
        case snippet
    }
}

extension Part {
    public enum VideoCategoriesList: String {
        case id
        case snippet
    }
}

extension Part {
    public enum SearchList: String {
        case id
        case snippet
    }
}

extension Part {
    public enum GuideCategoriesList: String {
        case id
        case snippet
    }
}

extension Part {
    public enum SubscriptionsList: String {
        case id
        case snippet
        case contentDetails
    }
}

extension Part {
    public enum VideoAbuseReportReasonsList: String {
        case id
        case snippet
    }
}

extension Part {
    public enum PlaylistsList: String {
        case id
        case snippet
        case status
    }
}

extension Part {
    public enum PlaylistItemsList: String {
        case id
        case snippet
        case contentDetails
        case status
    }
}

extension Part {
    public enum CommentThreadsList: String {
        case id
        case replies
        case snippet
    }
}

extension Part {
    public enum CommentList: String {
        case id
        case snippet
    }
}
