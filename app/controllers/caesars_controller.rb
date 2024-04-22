class CaesarsController < ApplicationController


	def mlb
		render :json => CaesarsLines::Mlb.fetch
	end

	def nhl
		render :json => CaesarsLines::Nhl.fetch
	end

	def nba
		render :json => CaesarsLines::Nba.fetch
	end

end