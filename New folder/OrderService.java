package stock_management.cs_stock.service.impl;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import stock_management.cs_stock.model.Order;
import stock_management.cs_stock.service.IOrderService;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;


@Service
@Slf4j
@RequiredArgsConstructor
public class OrderService implements IOrderService {
    private final ExecutorService executorService;
    private final List<Order> orderHistory = new ArrayList<>();
    public OrderService() {
        this.executorService = Executors.newFixedThreadPool(10);
    }

    @Override
    public void placeOrder(Order order) {
        executorService.submit(() -> {
            log.info("Placing order: {}", order);
            orderHistory.add(order);

        });
    }

    public List<Order> getOrderHistory() {
        return new ArrayList<>(orderHistory);
    }

    @Override
    public void shutdown() {
        executorService.shutdown();
    }
}


