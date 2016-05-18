@CommentForm = React.createClass
	displayName: 'CommentForm'

	propTypes:
		commentableType: React.PropTypes.string
		commentableId: React.PropTypes.number
		addCommentHandler: React.PropTypes.func
		isResponse: React.PropTypes.bool
		responseForCommentId: React.PropTypes.any
		addResponseHandler: React.PropTypes.func
		currentUser: React.PropTypes.object

	getDefaultProps: ->
		commentableType: ''
		commentableId: null
		addCommentHandler: null
		isResponse: false
		responseForCommentId: null
		addResponseHandler: null
		currentUser: null
		
	getInitialState: ->
		isBusy: false

	componentDidMount: ->
		@refs.postButton.disabled = true
		if @props.isResponse == true
			@refs.commentText.focus()

	handleOnChange: ->
		if @refs.commentText.value.trim() == ''
			@refs.postButton.disabled = true
		else
			@refs.postButton.disabled = false

	handleTextAutoResize: ->
		$(@refs.commentText).css({'height':'auto','overflow-y':'hidden'}).height(@refs.commentText.scrollHeight - 4)

	handleEnterKeySubmit: (e) ->
		if e.keyCode == 13 && not e.shiftKey == true
			e.preventDefault()
			@refs.postButton.click()

	handlePostComment: ->
		context = @
		if context.props.isResponse == false
			data =
				comment:
					content: context.refs.commentText.value
					commentable_type: context.props.commentableType
					commentable_id: context.props.commentableId
		else
			data =
				comment:
					content: context.refs.commentText.value
					commentable_type: 'Comment'
					commentable_id: context.props.responseForCommentId
		$.ajax
			method: 'POST'
			url: '/' + context.props.commentableType.toLowerCase() + 's/' + context.props.commentableId + '/comments'
			dataType: 'JSON'
			data: data
			timeout: 10000
			beforeSend: ->
				context.setState isBusy: true
			success: (result) ->
				console.log('comment created')
				context.setState isBusy: false
				if context.props.isResponse == false
					context.props.addCommentHandler(result.id, context.refs.commentText.value)
					context.refs.commentText.value = ''
					context.handleOnChange()
					context.handleTextAutoResize()
				else
					context.props.addResponseHandler(result.id, context.refs.commentText.value, context.props.responseForCommentId)
			error: (jqXHR, textStatus, errorThrown) ->
				if textStatus == 'timeout'
					alert("Sorry, it's taking too long for your comment to be sent. Please check your connection and try again.")
				else
					alert('Sorry, your comment could not be created. Please try again after some time.')
				context.setState isBusy: false

	render: ->
		React.DOM.div
			className: 'comment-form'
			React.DOM.div
				className: 'comment-form__container--' + if @props.isResponse == false then 'comment' else 'response'
				React.DOM.img
					className: 'comment-form__avatar--' + if @props.isResponse == false then 'comment' else 'response'
					src: @props.currentUser.avatar_path
					title: 'You'
				React.DOM.textarea
					ref: 'commentText'
					rows: 1
					className: 'comment-form__comment-text'
					placeholder:  if @props.isResponse == false then 'Write a comment...' else 'Write a reply...'
					onChange: @handleOnChange
					onInput: @handleTextAutoResize
					onKeyDown: @handleEnterKeySubmit
				React.DOM.button
					ref: 'postButton'
					className: 'comment-form__post-button--' + if @props.isResponse == false then 'comment' else 'response'
					disabled: if @state.isBusy == true then true else false
					onClick: @handlePostComment
					if @state.isBusy == true
						React.DOM.span
							className: null
							React.DOM.i
								className: 'fa fa-refresh fa-spin'
							React.DOM.span
								className: null
								' '
					'Post'
