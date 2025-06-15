// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract decentralisedMarketplace{

        //State
        struct Stock{
            uint id;
            string name;
            uint price;
            address payable seller;
            address buyer;
            bool sold;
            uint quantity;
        }

        Stock[] public stocks;

        //events
        event stockAdded(uint stockId, string name, uint price, address seller);
        event stockBought(uint stocKId, address buyer);

        //functions
        function addStock( string memory _name, uint _price, uint _quantity) public {
            require(_price > 0,"Invalid price tag" );
            require(_quantity > 0, "Quantity must be atleast 1");

            stocks.push(Stock(stocks.length,_name,_price,payable(msg.sender), address(0), false, _quantity));

            emit stockAdded(stocks.length - 1, _name, _price, msg.sender);
        }

        function buyStock (uint _stockId) public payable {
            require(_stockId < stocks.length, "Stock doesn't exist");
             
             Stock storage  stock = stocks[_stockId];
             require(!stock.sold, "stock has been sold");

             stock.seller.transfer(msg.value);

             emit stockBought(_stockId, msg.sender);
        }

        function viewAllAvailableStock() public view returns (Stock[] memory) {
            return stocks;
        }

        function updateStockPrice(uint _stockId, uint _newPrice) public {
            require(_stockId < stocks.length, "Stock doesn't exist");
            require(_newPrice > 0, " Price must be greater than 0");

            Stock storage stock = stocks[_stockId];

            require(msg.sender ==  stock.seller, "Only stock seller can update price");
            require(!stock.sold, "Can't update sold out stock" );

            stock.price = _newPrice;
        }

        function getStock(uint _stockId) public view returns (uint, string memory, uint, address, address, bool, uint){
            Stock memory stock = stocks[_stockId];
        return (
            stock.id,
            stock.name,
            stock.price,
            stock.seller,
            stock.buyer,
            stock.sold,
            stock.quantity
        );
        }

}