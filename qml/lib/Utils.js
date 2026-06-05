.pragma library

function resolveHandle(actorId, prefixChar) {
    if (!actorId)
        return "";
    var parts = actorId.split("/" + prefixChar + "/");
    if (parts.length < 2)
        return actorId;
    var name = parts[1];
    var urlParts = actorId.split("://");
    var domain = urlParts.length >= 2 ? urlParts[1].split("/")[0] : "";
    return domain ? name + "@" + domain : name;
}

function formatAuthor(actorId) {
    return resolveHandle(actorId, "u");
}

function resolveCommunityHandle(actorId) {
    return resolveHandle(actorId, "c");
}

function applyPostViewResult(result, page, appWindow, api) {
    var pv = result.post_view;
    page.postMyVote = pv.my_vote ? pv.my_vote : 0;
    page.postComments = pv.counts.comments;
    page.postScore = pv.counts.score;
    page.postTitle = pv.post.name;
    appWindow.postTitle = page.postTitle;
    appWindow.postScore = page.postScore;
    appWindow.postComments = page.postComments;
    if (api && pv.post && pv.post.id) {
        api.updatePostInModel(pv.post.id, pv);
    }
}

function applyCommentViewResult(result, api) {
    var cv = result.comment_view;
    if (cv && cv.comment && cv.comment.id) {
        api.updateCommentVote(cv.comment.id,
                              cv.my_vote ? cv.my_vote : 0,
                              cv.counts ? (cv.counts.score || 0) : 0);
    }
}
