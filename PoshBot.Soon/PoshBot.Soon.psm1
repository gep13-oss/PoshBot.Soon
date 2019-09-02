function Get-Soon {
    [PoshBot.BotCommand(
        Command = $false,
        TriggerType = 'regex',
        Regex = 'soon'
    )]
    [cmdletbinding()]
    param(
        [object[]]$Arguments
    )

    $imageArray =   "https://i.imgur.com/TVxNL84.png",
    "https://i.imgur.com/bFb5qZt.jpg",
    "https://i.imgur.com/qNiLQz3.png",
    "https://i.imgur.com/8niosvC.gif",
    "https://i.imgur.com/qX5jkRi.jpg",
    "https://i.imgur.com/Rqe94Xw.jpg",
    "https://i.imgur.com/i2leGDn.jpg",
    "https://i.imgur.com/QdnGKdY.jpg",
    "https://i.imgur.com/bkox94P.jpg",
    "https://i.imgur.com/hdG9IOk.jpg",
    "https://i.imgur.com/ne6T0UP.png",
    "https://i.imgur.com/41vZ1zP.png",
    "https://i.imgur.com/yweXMrA.jpg",
    "https://i.imgur.com/GcnzEjU.jpg",
    "https://i.imgur.com/J0PLa1k.jpg",
    "https://i.imgur.com/GHHLFqK.jpg",
    "https://i.imgur.com/o25zB5O.jpg",
    "https://i.imgur.com/6yyeCBR.jpg",
    "https://i.imgur.com/GKSdoAm.png",
    "https://i.imgur.com/3L0UQ8A.jpg",
    "https://i.imgur.com/7WhKHPh.gif",
    "https://i.imgur.com/xZuKr9v.gif",
    "https://i.imgur.com/GWSQBxx.jpg",
    "https://i.imgur.com/eCvTcTQ.jpg",
    "https://i.imgur.com/0ypfizN.jpg",
    "https://i.imgur.com/JyaroGd.jpg",
    "https://i.imgur.com/xUgmD93.jpg",
    "https://i.imgur.com/ftGheRE.jpg",
    "https://i.imgur.com/Y4ExtS5.gif",
    "https://i.imgur.com/pDXRVjp.jpg",
    "https://i.imgur.com/L2SZuzG.gif"

    $randomlySelectedImage = Get-Random -InputObject $imageArray

    # @devblackops - You could also use the New-PoshBotCardResponse -ImageUrl <url>
    if ($randomlySelectedImage) {
		New-PoshBotCardResponse -ImageUrl $randomlySelectedImage
    }
}