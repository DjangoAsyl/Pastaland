--[[

  The jokes module introduces the following:
  -- sends random jokes to the client 
  
  TODO: add more jokes

]]--

local funFacts = {
   "[\f0PASTA-TIP\f7] Eat your carbs!"
  ,"[\f0PASTA-TIP\f7] Carbohydrates stimulate serotonine production: eat pasta and be happy!"
  ,"[\f0PASTA-TIP\f7] Did you know Chinese people invented spaghetti? Problem is, they suck at cooking."
  ,"[\f0PASTA-TIP\f7] Did you know Thomas Jefferson introduced pasta in USA? Yeah, I don't care either."
  ,"[\f0PASTA-TIP\f7] Feeling hungry? Get yourself some awesome pasta!"
  ,"[\f0PASTA-TIP\f7] Never trust a woman who can't cook pasta. Never."
  ,"[\f0PASTA-TIP\f7] Hey, is that a pasta cup? I'm eating that, see you later!"
  ,"[\f0PASTA-TIP\f7] I'm not saying pasta is good. Pasta is BEST."
  ,"[\f0PASTA-TIP\f7] Did you hear about the italian chef that died? He pasta way."
  ,"[\f0PASTA-TIP\f7] What do blondes and spaghetti have in common? They both wiggle when you eat them."
  ,"[\f0PASTA-TIP\f7] Where did the spaghetti go to dance? To the meat-ball."
  ,"[\f0PASTA-TIP\f7] If you ate pasta and antipasta at the same time would you still be hungry?"
  ,"[\f0PASTA-TIP\f7] The trouble with eating pasta is that five or six days later you're hungry again!"
  ,"[\f0PASTA-TIP\f7] My girlfriend broke up with me the other day because she said I'm addicted to pasta. At the moment I'm feeling cannelloni."
  ,"[\f0PASTA-TIP\f7] Entered what I ate today into my new fitness app and it just sent an ambulance to my house."
  ,"[\f0PASTA-TIP\f7] Any salad can be a Caesar salad if you stab it enough."
  ,"[\f0PASTA-TIP\f7] I am on a seafood diet. Every time I see food, I eat it."
  ,"[\f2GIRL-TIP\f7] If i had a dollar for every girl that found me unattractive, they would eventually find me attractive."
  ,"[\f2GIRL-TIP\f7] A recent study has found that women who are a little overweight live longer than the men who mention it."
  ,"[\f2GIRL-TIP\f7] My ex wrote to me: Can you delete my number? I responded: Who is this?"
  ,"[\f2GIRL-TIP\f7] Is google a woman? Because it won't let you finish your sentence without coming up with other suggestions"
  ,"[\f2GIRL-TIP\f7] What's six inches long, two inches wide, and drives women wild? Money."
  ,"[\f2GIRL-TIP\f7] Telling a girl to calm down works about as well as trying to baptize a cat."
  ,"[\f2GIRL-TIP\f7] Never laugh at your girlfriends choices. You are one of them."
  ,"[\f2GIRL-TIP\f7] My girlfriend had her driver's test the other day. She got 8 out of 10. The other 2 guys jumped clear."
  ,"[\f2GIRL-TIP\f7] She wanted a puppy. But I didn't want a puppy. So we compromised and got a puppy."
  ,"[\f2GIRL-TIP\f7] What's the difference between your wife and your job? After five years your job will still suck."
  ,"[\f2GIRL-TIP\f7] You should argue with your girlfriend only when she's not around."
  ,"[\f2GIRL-TIP\f7] The biggest difference between men and women is what comes to mind when the word 'Facial' is used."
  ,"[\f2GIRL-TIP\f7] Makeup tip: You're not in the circus."
  ,"[\f2GIRL-TIP\f7] My girlfriends dad asked me what I do. Apparently, 'your daughter' wasn't the right answer."
  ,"[\f2GIRL-TIP\f7] Why did Eve bite the forbidden apple? Because it tasted better than Adam's banana."
  ,"[\f2GIRL-TIP\f7] Having sex in an elevator is wrong on so many levels."
  ,"[\f2GIRL-TIP\f7] A girl phoned me the other day and said, 'Come on over, there's nobody home.' I went over. Nobody was home."
  ,"[\f2GIRL-TIP\f7] My girlfriend told me to go out and get something that makes her look sexy. So I got drunk."
  ,"[\f2GIRL-TIP\f7] What is the difference between 'ooooooh' and 'aaaaaaah'? About three inches."
  ,"[\f2GIRL-TIP\f7] Three words to ruin a man's ego: 'Is it in?'"
  ,"[\f2GIRL-TIP\f7] What should you do if your girlfriend starts smoking? Slow down and use a lubricant."
  ,"[\f2GIRL-TIP\f7] Early to bed, early to rise, makes a man sexually deprived."
  ,"[\f2GIRL-TIP\f7] Avoid arguments about the toilet seat. Use the sink."
  ,"[\f2GIRL-TIP\f7] Why do Women have legs? So they don't leave snail trails on the ground"
  ,"[\f2GIRL-TIP\f7] How do you fix a woman's watch? Why should you - there's a clock on the oven."
  ,"[\f2GIRL-TIP\f7] I haven't spoken to my wife for 18 months. I don't like to interrupt her."
  ,"[\f2GIRL-TIP\f7] My girlfriend thinks that I'm a stalker. Well, she's not exactly my girlfriend yet."
  ,"[\f2GIRL-TIP\f7] Our last fight was my fault: My wife asked me 'What's on the TV?' I said, 'Dust!'"
  ,"[\f2GIRL-TIP\f7] The most effective way to remember your wife's birthday is to forget it once."
  ,"[\f2GIRL-TIP\f7] Why did the woman cross the road? Who cares, what's she doing out of the kitchen?"  
  ,"[\f2GIRL-TIP\f7] How do you turn a fox into an elephant? Marry It!"
  ,"[\f2GIRL-TIP\f7] What is the difference between a battery and a woman? A battery has a positive side."
  ,"[\f2GIRL-TIP\f7] How are fat girls and mopeds alike? They're both fun to ride until your friends find out."
  ,"[\f2GIRL-TIP\f7] Why do women rub their eyes when they wake up? Because they don't have balls to scratch."
  ,"[\f2GIRL-TIP\f7] Why do husbands die before their wives? They want to."
  ,"[\f2GIRL-TIP\f7] Her: 'I look fat. Can you give me a compliment?' Me: 'You have perfect eyesight.'"
  ,"[\f2GIRL-TIP\f7] Relationships are a lot like algebra. Have you ever looked at your X and wondered Y?"
  ,"[\f2GIRL-TIP\f7] If I ever need a heart transplant, I'd want my ex's. It's never been used."
  ,"[\f2GIRL-TIP\f7] My wife and I were happy for twenty years. Then we met."
  ,"[\f2GIRL-TIP\f7] Outvoted 1-1 by my girlfriend again."
  ,"[\f2GIRL-TIP\f7] My girlfriend and I always compromise. I admit I'm wrong and she agrees with me."
  ,"[\f5FOOD-FOR-THOUGHT\f7] I hope actress Jessica Biel names her first born child Batmo."
  ,"[\f5FOOD-FOR-THOUGHT\f7] I'd kill for a Nobel Peace Prize."  
  ,"[\f5FOOD-FOR-THOUGHT\f7] There is no 'me' in team. No, wait, yes there is!"
  ,"[\f5FOOD-FOR-THOUGHT\f7] I think it's wrong that only one company makes the game Monopoly."
  ,"[\f5FOOD-FOR-THOUGHT\f7] Iron Man and Iron Woman? One's a superhero and the other is an instruction."
  ,"[\f4MOTIVATION\f7] 100,000 sperm and you were the fastest?"
  ,"[\f4MOTIVATION\f7] Your birth certificate is an apology letter from the condom factory."
  ,"[\f4MOTIVATION\f7] Wow, I did it, I finallyfixedthismotherfuckingspacebar"
  ,"[\f4MOTIVATION\f7] The proper way to use a stress ball is to throw it at the last person to piss you off."
  ,"[\f5ADVERT.\f7] Boycott shampoo! Demand the REAL poo!" 
  ,"[\f3PRO-TIP\f7] Badass players use /texreduce 12"
  ,"[\f3PRO-TIP\f7] Badass players use /forceplayermodels 1"
  ,"[\f3PRO-TIP\f7] Badass players use /fullbrightmodels 200"
  ,"[\f3PRO-TIP\f7] Smart players use /showclientnum 1"
}

local function randomFact()
    --math.randomseed(os.time())
    return funFacts[math.random(#funFacts)]
end

spaghetti.later(21000, function()
  return server.sendservmsg(randomFact());
end, true)