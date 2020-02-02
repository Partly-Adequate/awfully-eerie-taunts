AET.extension_handler = {}
AET.extensions = {}

function AET.extension_handler.OnMenuOpened()
	for _, extension in ipairs(AET.extensions) do
		if extension.is_enabled and extension.OnMenuOpened  then
			extension.OnMenuOpened()
		end
	end
end

function AET.extension_handler.OnMenuClosed()
	for _, extension in ipairs(AET.extensions) do
		if extension.is_enabled and extension.OnMenuClosed  then
			extension.OnMenuClosed()
		end
	end
end

function AET.extension_handler.OnTauntAttempted(taunt)
	for _, extension in ipairs(AET.extensions) do
		if extension.is_enabled and extension.OnTauntAttempted  then
			extension.OnTauntAttempted(taunt)
		end
	end
end

function AET.extension_handler.OnTauntAddedToFavorites(taunt)
	for _, extension in ipairs(AET.extensions) do
		if extension.is_enabled and extension.OnTauntAddedToFavorites  then
			extension.OnTauntAddedToFavorites(taunt)
		end
	end
end

function AET.extension_handler.OnTauntRemovedFromFavorites(taunt)
	for _, extension in ipairs(AET.extensions) do
		if extension.is_enabled and extension.OnTauntRemovedFromFavorites  then
			extension.OnTauntRemovedFromFavorites(taunt)
		end
	end
end

function AET.extension_handler.OnErrorInvalidPerms(taunt)
	for _, extension in ipairs(AET.extensions) do
		if extension.is_enabled and extension.OnErrorInvalidPerms  then
			extension.OnErrorInvalidPerms(taunt)
		end
	end
end

function AET.extension_handler.OnErrorInvalidID(taunt)
	for _, extension in ipairs(AET.extensions) do
		if extension.is_enabled and extension.OnErrorInvalidID  then
			extension.OnErrorInvalidID(taunt)
		end
	end
end

function AET.extension_handler.OnErrorAlreadyTaunting(taunt)
	for _, extension in ipairs(AET.extensions) do
		if extension.is_enabled and extension.OnErrorAlreadyTaunting  then
			extension.OnErrorAlreadyTaunting(taunt)
		end
	end
end

function AET.extension_handler.OnSuccess(taunt)
	for _, extension in ipairs(AET.extensions) do
		if extension.is_enabled and extension.OnSuccess  then
			extension.OnSuccess(taunt)
		end
	end
end
